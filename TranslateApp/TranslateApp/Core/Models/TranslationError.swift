//
//  TranslationError.swift
//  TranslateApp
//
//  Created by Aleksandr Meshchenko on 03.09.25.
//

import Foundation

// MARK: - Translation Error
enum TranslationError: Error, Equatable {
    case networkError(String)
    case apiError(String)
    case invalidResponse
    case emptyInput
    case unsupportedLanguage
    case rateLimitExceeded
    
    var localizedDescription: String {
        switch self {
        case .networkError(let message):
            return "Network error: \(message)"
        case .apiError(let message):
            return "API error: \(message)"
        case .invalidResponse:
            return "Invalid response from server"
        case .emptyInput:
            return "Please enter text to translate"
        case .unsupportedLanguage:
            return "This language pair is not supported"
        case .rateLimitExceeded:
            return "Too many requests. Please try again later"
        }
    }
}

// MARK: - Audio Playback State
enum AudioPlayback: Equatable {
    case source
    case target
}
