//
//  AppAction.swift
//  TranslateApp
//
//  Created by Aleksandr Meshchenko on 03.09.25.
//

import Foundation

// MARK: - App Actions
/// All possible actions that can be dispatched to the store
enum AppAction: Equatable {
    
    // MARK: - Text Input Actions
    case updateSourceText(String) /// User entered or modified source text
    case clearText
    case copyTranslation /// Copy translated text to clipboard
    
    // MARK: - Translation Actions
    case translate /// Initiate translation request
    case translationReceived(Result<TranslationResult, TranslationError>) /// response  from API
    
    // MARK: - Language Selection Actions
    case selectSourceLanguage(Language)
    case selectTargetLanguage(Language)
    case swapLanguages
    case toggleSourceLanguagePicker
    case toggleTargetLanguagePicker
    
    // MARK: - Favorite Languages (Advanced)
    case toggleFavoriteLanguage(Language)
    case setFavoriteLanguages(Set<Language>) /// Set multiple favorite languages at once
    
    // MARK: - Audio Actions (Advanced)
    case playSourceAudio /// Play text-to-speech for source text
    case playTranslatedAudio /// Play text-to-speech for translated text
    case stopAudio /// Stop currently playing audio
    case audioPlaybackCompleted /// Audio playback completed
    case toggleAudioFeature /// Toggle audio feature on/off
    
    // MARK: - Persistence Actions (Advanced)
    case saveLanguagePreferences /// Save current language pair to user defaults
    case loadLanguagePreferences
    case languagePreferencesLoaded(LanguagePair)
    
    // MARK: - Error Handling
    case clearError /// Clear current error
    case setError(TranslationError)
    
    // MARK: - App Lifecycle
    case appDidBecomeActive
    case appWillResignActive
    
    /// Actions to show settings and switch:
    case setSettingsPresented(Bool)
    case setAutoTranslate(Bool)
    case loadUserPreferences
}

// MARK: - Action Validation
extension AppAction {
    /// Validate if action can be performed with given state
    static func validate(_ action: AppAction, with state: AppState) -> Bool {
        switch action {
        case .translate:
            return state.canTranslate
        case .swapLanguages:
            return state.canSwapLanguages
        case .copyTranslation:
            return !state.translatedText.isEmpty
        case .playSourceAudio:
            return !state.sourceText.isEmpty && state.isAudioEnabled
        case .playTranslatedAudio:
            return !state.translatedText.isEmpty && state.isAudioEnabled
        default:
            return true
        }
    }
}
