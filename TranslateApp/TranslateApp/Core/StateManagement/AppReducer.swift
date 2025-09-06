//
//  AppReducer.swift
//  TranslateApp
//
//  Created by Aleksandr Meshchenko on 04.09.25.
//


import Foundation
#if os(iOS)
import UIKit
#endif

// MARK: - Main App Reducer
struct AppReducer: Reducer {
    typealias State = AppState
    typealias Action = AppAction
    
    enum DebounceID {
        static let autoTranslateOnTyping = "autoTranslate.typing"
        static let autoTranslateOnLanguageChange = "autoTranslate.languageChange"
        static let autoTranslateOnSwap = "autoTranslate.swap"
    }
    
    func reduce(state: inout AppState, action: AppAction) -> Effect<AppAction> {
        switch action {
            // MARK: - Text Input Actions
        case .updateSourceText(let text):
            state.sourceText = text
            state.error = nil
            
            // Cancel the previous transfer if it is in process
            if state.isLoading {
                // Need to cancel here, but now just drop the flag
                state.isLoading = false
            }
            
            // If we clear the field - we clear the result and do not run anything
            if text.isEmpty {
                state.translatedText = ""
                return .none
            }
            
            // auto-translation only if enabled
            guard state.isAutoTranslateEnabled else { return .none }
            
            // Auto-translation with debounce (approximately 600 ms)
            // The previous deboot with the same id will be canceled at each new input
            return Effect.debounce(id: DebounceID.autoTranslateOnTyping, for: 0.6) { .translate }
            
        case .clearText:
            state.sourceText = ""
            state.translatedText = ""
            state.error = nil
            return .none
            
        case .copyTranslation:
            // Capture text before creating effect
            let textToCopy = state.translatedText
            
            return Effect { dispatch in
#if os(iOS)
                await MainActor.run {
                    UIPasteboard.general.string = textToCopy
                }
#endif
                // TODO: Add success feedback
            }
            
            // MARK: - Translation Actions
        case .translate:
            // Если уже идет загрузка - не запускаем новый запрос
            guard !state.isLoading else {
                return .none
            }
            
            // In case the debounce "shoots" at the moment when canTranslate == false,
            // we have the guard:
            guard state.canTranslate && state.sourceText.count >= 2 else {
                return .none
            }
            
            state.isLoading = true
            state.error = nil
            
            // Capture values for translation
            let text = state.sourceText
            let source = state.sourceLanguage
            let target = state.targetLanguage
            
            return Effect { dispatch in
                do {
                    // Call real translation API
                    let translation = try await TranslationService.shared.translate(
                        text: text,
                        from: source,
                        to: target
                    )
                    
                    //                    // Mock implementation for now
                    //                    try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second delay
                    //
                    //                    // Create mock translation with language info
                    //                    let mockTranslation = Self.createMockTranslation(
                    //                        text: text,
                    //                        from: source,
                    //                        to: target
                    //                    )
                    //
                    //                    dispatch(.translationReceived(.success(mockTranslation)))
                    dispatch(.translationReceived(.success(translation)))
                } catch let error as TranslationError {
                    // Handle known translation errors
                    dispatch(.translationReceived(.failure(error)))
                } catch {
                    // Handle errors
                    let translationError = Self.mapToTranslationError(error)
                    dispatch(.translationReceived(.failure(translationError)))
                }
            }
            
        case .translationReceived(let result):
            state.isLoading = false
            
            switch result {
            case .success(let translation):
                state.translatedText = translation
                state.error = nil
                
            case .failure(let error):
                state.error = error
                state.translatedText = ""
            }
            return .none
            
        // MARK: - Language Selection Actions
        case .selectSourceLanguage(let language):
            state.sourceLanguage = language
            state.isShowingSourceLanguagePicker = false
            // Clear translation as language changed
            state.translatedText = ""
            
            let savePrefs = Effect.immediate(AppAction.saveLanguagePreferences)
            let maybeTranslate = (state.isAutoTranslateEnabled && !state.sourceText.isEmpty)
                ? Effect.debounce(id: DebounceID.autoTranslateOnLanguageChange, for: 0.2) { AppAction.translate }
                : .none
            
            return .batch([savePrefs, maybeTranslate])
            
        case .selectTargetLanguage(let language):
            state.targetLanguage = language
            state.isShowingTargetLanguagePicker = false
            // Clear translation as language changed
            state.translatedText = ""
            
            let savePrefs = Effect.immediate(AppAction.saveLanguagePreferences)
            let maybeTranslate = (state.isAutoTranslateEnabled && !state.sourceText.isEmpty)
                ? Effect.debounce(id: DebounceID.autoTranslateOnLanguageChange, for: 0.2) { AppAction.translate }
                : .none
            
            return .batch([savePrefs, maybeTranslate])
            
        case .swapLanguages:
            print("Before swap: \(state.sourceLanguage.displayName) → \(state.targetLanguage.displayName)")
            
            let temp = state.sourceLanguage
            state.sourceLanguage = state.targetLanguage
            state.targetLanguage = temp
            
            print("After swap: \(state.sourceLanguage.displayName) → \(state.targetLanguage.displayName)")
            
            // Swap texts if translation exists
            if !state.translatedText.isEmpty {
                let tempText = state.sourceText
                state.sourceText = state.translatedText
                state.translatedText = tempText
            }
            
            // Save after exchange
            // Easy debounce 200 ms is enough: the language change is usually a single action.
            let savePrefs = Effect.immediate(AppAction.saveLanguagePreferences)
            let maybeTranslate = (state.isAutoTranslateEnabled && !state.sourceText.isEmpty)
                ? Effect.debounce(id: DebounceID.autoTranslateOnSwap, for: 0.2) { AppAction.translate }
                : .none
            
            return .batch([savePrefs, maybeTranslate])
            
        case .toggleSourceLanguagePicker:
            state.isShowingSourceLanguagePicker.toggle()
            state.isShowingTargetLanguagePicker = false
            return .none
            
        case .toggleTargetLanguagePicker:
            state.isShowingTargetLanguagePicker.toggle()
            state.isShowingSourceLanguagePicker = false
            return .none
            
            // MARK: - Favorite Languages (Advanced)
        case .toggleFavoriteLanguage(let language):
            if state.favoriteLanguages.contains(language) {
                state.favoriteLanguages.remove(language)
            } else {
                state.favoriteLanguages.insert(language)
            }
            // Save favorites to UserDefaults
            return .immediate(.saveLanguagePreferences)
            
        case .setFavoriteLanguages(let languages):
            state.favoriteLanguages = languages
            return .immediate(.saveLanguagePreferences)
            
            // MARK: - Audio Actions (Advanced)
        case .playSourceAudio:
            guard !state.sourceText.isEmpty, state.isAudioEnabled else { return .none }
            
            state.playingAudio = .source
            let text = state.sourceText
            let language = state.sourceLanguage
            
            // Формируем URL для Google TTS
            let audioURL = "https://translate.google.com/translate_tts?ie=UTF-8&client=tw-ob&tl=\(language.rawValue)&q=\(text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"

            return Effect { dispatch in
                // TODO: Implement with TextToSpeechService
                await TextToSpeechService.shared.playFromURL(audioURL)
                
                // Mock delay for now
                //try? await Task.sleep(nanoseconds: 2_000_000_000)
                dispatch(.audioPlaybackCompleted)
            }
            
        case .playTranslatedAudio:
            guard !state.translatedText.isEmpty, state.isAudioEnabled else { return .none }
            
            state.playingAudio = .target
            let text = state.translatedText
            let language = state.targetLanguage
            
            return Effect { dispatch in
                // TODO: Implement with TextToSpeechService
                // await TextToSpeechService.shared.speak(text, language: language)
                
                // Mock delay for now
                try? await Task.sleep(nanoseconds: 2_000_000_000)
                dispatch(.audioPlaybackCompleted)
            }
            
        case .stopAudio:
            state.playingAudio = nil
            // TODO: Stop TextToSpeechService
            return .none
            
        case .audioPlaybackCompleted:
            state.playingAudio = nil
            return .none
            
        case .toggleAudioFeature:
            state.isAudioEnabled.toggle()
            if !state.isAudioEnabled {
                state.playingAudio = nil
            }
            return .none
            
            // MARK: - Persistence Actions (Advanced)
        case .saveLanguagePreferences:
            let pair = LanguagePair(
                source: state.sourceLanguage,
                target: state.targetLanguage
            )
            state.lastUsedLanguagePair = pair
            
            // Save to UserDefaults
            let favorites = state.favoriteLanguages
            return Effect { dispatch in
                UserDefaults.standard.set(pair.source.rawValue, forKey: "sourceLanguage")
                UserDefaults.standard.set(pair.target.rawValue, forKey: "targetLanguage")
                
                // Save favorites
                let favoritesCodes = favorites.map { $0.rawValue }
                UserDefaults.standard.set(favoritesCodes, forKey: "favoriteLanguages")
            }
            
        case .loadLanguagePreferences:
            return Effect { dispatch in
                // Load language pair
                if let sourceCode = UserDefaults.standard.string(forKey: "sourceLanguage"),
                   let targetCode = UserDefaults.standard.string(forKey: "targetLanguage"),
                   let source = Language(rawValue: sourceCode),
                   let target = Language(rawValue: targetCode) {
                    
                    let pair = LanguagePair(source: source, target: target)
                    dispatch(.languagePreferencesLoaded(pair))
                }
                
                // Load favorites
                if let favoritesCodes = UserDefaults.standard.array(forKey: "favoriteLanguages") as? [String] {
                    let favorites = Set(favoritesCodes.compactMap { Language(rawValue: $0) })
                    dispatch(.setFavoriteLanguages(favorites))
                }
            }
            
        case .languagePreferencesLoaded(let pair):
            state.sourceLanguage = pair.source
            state.targetLanguage = pair.target
            state.lastUsedLanguagePair = pair
            return .none
            
            // MARK: - Error Handling
        case .clearError:
            state.error = nil
            return .none
            
        case .setError(let error):
            state.error = error
            state.isLoading = false
            return .none
            
            // MARK: - App Lifecycle
        case .appDidBecomeActive:
            return .immediate(.loadLanguagePreferences)
            
        case .appWillResignActive:
            return .immediate(.saveLanguagePreferences)
            
        // React to settings screens and load/save.
        // Take into account auto-translation in updateSourceText and when changing languages.
        case .setSettingsPresented(let presented):
            state.isSettingsPresented = presented
            return .none

        case .setAutoTranslate(let isOn):
            state.isAutoTranslateEnabled = isOn
            UserDefaults.standard.set(isOn, forKey: "autoTranslateEnabled")

            // Если включили авто-перевод и есть текст - сразу дернём перевод с лёгким дебаунсом
            guard isOn, !state.sourceText.isEmpty else { return .none }
            return Effect.debounce(id: "autoTranslate", for: 0.2) { .translate }

        case .loadUserPreferences:
            if UserDefaults.standard.object(forKey: "autoTranslateEnabled") != nil {
                state.isAutoTranslateEnabled = UserDefaults.standard.bool(forKey: "autoTranslateEnabled")
            }
            return .none
        }
        
    }
    
    // MARK: - Private Helper Methods
    /// Map errors to TranslationError type
    private static func mapToTranslationError(_ error: Error) -> TranslationError {
        if let urlError = error as? URLError {
            switch urlError.code {
            case .notConnectedToInternet:
                return .networkError("No internet connection")
            case .timedOut:
                return .networkError("Request timed out")
            default:
                return .networkError(urlError.localizedDescription)
            }
        }
        
        // Default error
        return .apiError(error.localizedDescription)
    }
}
