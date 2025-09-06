//
//  AppState.swift
//  TranslateApp
//
//  Created by Aleksandr Meshchenko on 03.09.25.
//


import Foundation

// MARK: - Main App State
/// The single source of truth for the entire application
struct AppState: Equatable {
    // MARK: - Translation State
    /// Current text entered by user for translation
    var sourceText: String = ""
    
    /// Translated text received from API
    var translatedText: String = ""
    
    /// Currently selected source language
    var sourceLanguage: Language = .english
    
    /// Currently selected target language  
    var targetLanguage: Language = .spanish
    
    // MARK: - UI State
    /// Indicates if translation is in progress
    var isLoading: Bool = false
    
    /// Current error if any operation failed
    var error: TranslationError? = nil
    
    /// Show/hide language picker for source
    var isShowingSourceLanguagePicker: Bool = false
    
    /// Show/hide language picker for target
    var isShowingTargetLanguagePicker: Bool = false
    
    // MARK: - User Preferences (Advanced)
    /// Languages marked as favorites for quick access
    var favoriteLanguages: Set<Language> = []
    
    /// Last selected language pair (for persistence)
    var lastUsedLanguagePair: LanguagePair? = nil
    
    // MARK: - Feature Flags
    /// Enable text-to-speech functionality
    var isAudioEnabled: Bool = true
    
    /// Currently playing audio (source or target)
    var playingAudio: AudioPlayback? = nil
    
    // Settings
    var isAutoTranslateEnabled: Bool = true
    var isSettingsPresented: Bool = false
    
    var lastSourceAudioURL: String?
    var lastDestinationAudioURL: String?
}


// MARK: - State Extensions
extension AppState {
    /// Check if translation can be performed
    var canTranslate: Bool {
        !sourceText.isEmpty &&
        !isLoading &&
        sourceLanguage != targetLanguage
    }
    
    /// Check if languages can be swapped
    var canSwapLanguages: Bool {
        !isLoading
    }
    
    /// Get favorite languages sorted alphabetically
    var sortedFavoriteLanguages: [Language] {
        favoriteLanguages.sorted { $0.displayName < $1.displayName }
    }
    
    /// Get non-favorite languages
    var nonFavoriteLanguages: [Language] {
        Language.allCases.filter { !favoriteLanguages.contains($0) }
    }
}

// MARK: - Initial State
extension AppState {
    /// Default initial state for the app
    static var initial: AppState {
        AppState(
            sourceText: "",
            translatedText: "",
            sourceLanguage: .english,
            targetLanguage: .spanish,
            isLoading: false,
            error: nil,
            isShowingSourceLanguagePicker: false,
            isShowingTargetLanguagePicker: false,
            favoriteLanguages: [],
            lastUsedLanguagePair: nil,
            isAudioEnabled: true,
            playingAudio: nil
        )
    }
    
    /// State for previews and testing
    static var preview: AppState {
        AppState(
            sourceText: "Hello, world!",
            translatedText: "¡Hola, mundo!",
            sourceLanguage: .english,
            targetLanguage: .spanish,
            isLoading: false,
            error: nil,
            isShowingSourceLanguagePicker: false,
            isShowingTargetLanguagePicker: false,
            favoriteLanguages: [.spanish, .french, .german],
            lastUsedLanguagePair: LanguagePair(source: .english, target: .spanish),
            isAudioEnabled: true,
            playingAudio: nil
        )
    }
}
