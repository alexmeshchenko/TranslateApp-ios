//
//  TranslationRequest.swift
//  TranslateApp
//
//  Created by Aleksandr Meshchenko on 05.09.25.
//


// MARK: - Request/Response Models
struct TranslationRequest: Codable {
    let q: String    // query text
    let sl: String   // source language
    let dl: String   // destination language
}


// MARK: - Alternative API Request Format
// Some translation APIs use different parameter names
struct AlternativeTranslationRequest: Codable {
    let text: String
    let source: String
    let target: String
    
    enum CodingKeys: String, CodingKey {
        case text
        case source = "source_lang"
        case target = "target_lang"
    }
}
