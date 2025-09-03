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
    /// User entered or modified source text
    case updateSourceText(String)
    
    /// Clear all text fields
    case clearText
    
    /// Copy translated text to clipboard
    case copyTranslation
    
    // MARK: - Translation Actions
    /// Initiate translation request
    case translate
    
    /// Translation response received from API
    case translationReceived(Result<String, TranslationError>)
    
    // MARK: - Language Selection Actions
    /// Select source language
    case selectSourceLanguage(Language)
    
    /// Select target language
    case selectTargetLanguage(Language)
    
    /// Swap source and target languages
    case swapLanguages
    
    /// Show/hide source language picker
    case toggleSourceLanguagePicker
    
    /// Show/hide target language picker
    case toggleTargetLanguagePicker
    
    // MARK: - Favorite Languages (Advanced)
    /// Toggle language favorite status
    case toggleFavoriteLanguage(Language)
    
    /// Set multiple favorite languages at once
    case setFavoriteLanguages(Set<Language>)
    
    // MARK: - Audio Actions (Advanced)
    /// Play text-to-speech for source text
    case playSourceAudio
    
    /// Play text-to-speech for translated text  
    case playTranslatedAudio
    
    /// Stop currently playing audio
    case stopAudio
    
    /// Audio playback completed
    case audioPlaybackCompleted
    
    /// Toggle audio feature on/off
    case toggleAudioFeature
    
    // MARK: - Persistence Actions (Advanced)
    /// Save current language pair to user defaults
    case saveLanguagePreferences
    
    /// Load saved language preferences
    case loadLanguagePreferences
    
    /// Language preferences loaded from storage
    case languagePreferencesLoaded(LanguagePair)
    
    // MARK: - Error Handling
    /// Clear current error
    case clearError
    
    /// Set error manually
    case setError(TranslationError)
    
    // MARK: - App Lifecycle
    /// App did become active
    case appDidBecomeActive
    
    /// App will resign active
    case appWillResignActive
}

// MARK: - Action Descriptions (for debugging)
extension AppAction: CustomStringConvertible {
    var description: String {
        switch self {
        case .updateSourceText(let text):
            return "updateSourceText(\(text.prefix(20))...)"
        case .clearText:
            return "clearText"
        case .copyTranslation:
            return "copyTranslation"
        case .translate:
            return "translate"
        case .translationReceived(let result):
            switch result {
            case .success(let text):
                return "translationReceived(success: \(text.prefix(20))...)"
            case .failure(let error):
                return "translationReceived(failure: \(error))"
            }
        case .selectSourceLanguage(let lang):
            return "selectSourceLanguage(\(lang.displayName))"
        case .selectTargetLanguage(let lang):
            return "selectTargetLanguage(\(lang.displayName))"
        case .swapLanguages:
            return "swapLanguages"
        case .toggleSourceLanguagePicker:
            return "toggleSourceLanguagePicker"
        case .toggleTargetLanguagePicker:
            return "toggleTargetLanguagePicker"
        case .toggleFavoriteLanguage(let lang):
            return "toggleFavoriteLanguage(\(lang.displayName))"
        case .setFavoriteLanguages(let langs):
            return "setFavoriteLanguages(\(langs.count) languages)"
        case .playSourceAudio:
            return "playSourceAudio"
        case .playTranslatedAudio:
            return "playTranslatedAudio"
        case .stopAudio:
            return "stopAudio"
        case .audioPlaybackCompleted:
            return "audioPlaybackCompleted"
        case .toggleAudioFeature:
            return "toggleAudioFeature"
        case .saveLanguagePreferences:
            return "saveLanguagePreferences"
        case .loadLanguagePreferences:
            return "loadLanguagePreferences"
        case .languagePreferencesLoaded(let pair):
            return "languagePreferencesLoaded(\(pair.source.displayName) → \(pair.target.displayName))"
        case .clearError:
            return "clearError"
        case .setError(let error):
            return "setError(\(error))"
        case .appDidBecomeActive:
            return "appDidBecomeActive"
        case .appWillResignActive:
            return "appWillResignActive"
        }
    }
}

// MARK: - Action Categories (for middleware/logging)
extension AppAction {
    /// Category for organizing actions
    enum Category {
        case input
        case translation
        case language
        case audio
        case persistence
        case error
        case lifecycle
    }
    
    /// Get category of the action
    var category: Category {
        switch self {
        case .updateSourceText, .clearText, .copyTranslation:
            return .input
        case .translate, .translationReceived:
            return .translation
        case .selectSourceLanguage, .selectTargetLanguage, .swapLanguages,
             .toggleSourceLanguagePicker, .toggleTargetLanguagePicker,
             .toggleFavoriteLanguage, .setFavoriteLanguages:
            return .language
        case .playSourceAudio, .playTranslatedAudio, .stopAudio,
             .audioPlaybackCompleted, .toggleAudioFeature:
            return .audio
        case .saveLanguagePreferences, .loadLanguagePreferences, .languagePreferencesLoaded:
            return .persistence
        case .clearError, .setError:
            return .error
        case .appDidBecomeActive, .appWillResignActive:
            return .lifecycle
        }
    }
    
    /// Check if action has side effects
    var hasSideEffects: Bool {
        switch self {
        case .translate, .copyTranslation, .playSourceAudio, .playTranslatedAudio,
             .saveLanguagePreferences, .loadLanguagePreferences:
            return true
        default:
            return false
        }
    }
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
