//
//  AppAction+Debug.swift
//  TranslateApp
//
//  Created by Aleksandr Meshchenko on 06.09.25.
//


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
            case .success(let translation):
                return "translationReceived(success: \(translation.text.prefix(20))...)"
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
            
            //  Settings actions
        case .setSettingsPresented(let presented):
            return "setSettingsPresented(\(presented))"
        case .setAutoTranslate(let isOn):
            return "setAutoTranslate(\(isOn))"
        case .loadUserPreferences:
            return "loadUserPreferences"
        }
    }
}
