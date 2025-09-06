//
//  AppAction+Category.swift
//  TranslateApp
//
//  Created by Aleksandr Meshchenko on 06.09.25.
//


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
        
        // --- Input actions ---
        case .updateSourceText, .clearText, .copyTranslation:
            return .input
            
        // --- Translation process ---
        case .translate,
             .translationReceived:
            return .translation
        
        // --- Language selection / swap ---
        case .selectSourceLanguage,
             .selectTargetLanguage,
             .swapLanguages,
             .toggleSourceLanguagePicker, .toggleTargetLanguagePicker,
             .toggleFavoriteLanguage, .setFavoriteLanguages:
            return .language
            
        // --- Audio ---
        case .playSourceAudio,
             .playTranslatedAudio,
             .stopAudio,
             .audioPlaybackCompleted,
             .toggleAudioFeature:
            return .audio
            
        // --- Persistence (settings, preferences) ---
        case .saveLanguagePreferences,
             .loadLanguagePreferences,
             .setSettingsPresented,
             .setAutoTranslate,
             .languagePreferencesLoaded,
             .loadUserPreferences:
            return .persistence
            
        // --- Errors ---
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
