//
//  TranslationResponse.swift
//  TranslateApp
//
//  Created by Aleksandr Meshchenko on 05.09.25.
//


import Foundation

// MARK: - Translation Response Model
struct TranslationResponse: Codable {
    let sourceLanguage: String
    let sourceText: String
    let destinationLanguage: String
    let destinationText: String
    let pronunciation: Pronunciation?
    let translations: Translations?
    let definitions: [Definition]?
    let seeAlso: [String]?
    
    enum CodingKeys: String, CodingKey {
        case sourceLanguage = "source-language"
        case sourceText = "source-text"
        case destinationLanguage = "destination-language"
        case destinationText = "destination-text"
        case pronunciation
        case translations
        case definitions
        case seeAlso = "see-also"
    }
}

// MARK: - Definition
struct Definition: Codable {
    let partOfSpeech: String?
    let definition: String?
    let example: String?
    let otherExamples: [String]?
    let synonyms: [String]?
    
    enum CodingKeys: String, CodingKey {
        case partOfSpeech = "part-of-speech"
        case definition
        case example
        case otherExamples = "other-examples"
        case synonyms
    }
}

// MARK: - Pronunciation
struct Pronunciation: Codable {
    let sourceTextPhonetic: String?
    let sourceTextAudio: String?
    let destinationTextAudio: String?
    
    enum CodingKeys: String, CodingKey {
        case sourceTextPhonetic = "source-text-phonetic"
        case sourceTextAudio = "source-text-audio"
        case destinationTextAudio = "destination-text-audio"
    }
}

// MARK: - Translations
struct Translations: Codable {
    let allTranslations: [String]?
    let possibleTranslations: [String]?
    let possibleMistakes: [String]?
    
    enum CodingKeys: String, CodingKey {
        case allTranslations = "all-translations"
        case possibleTranslations = "possible-translations"
        case possibleMistakes = "possible-mistakes"
    }
}
