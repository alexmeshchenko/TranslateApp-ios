//
//  Language.swift
//  TranslateApp
//
//  Created by Aleksandr Meshchenko on 03.09.25.
//

import Foundation

// MARK: - Language Model
enum Language: String, CaseIterable, Codable, Hashable {
    // Most common languages
    case english = "en"
    case spanish = "es"
    case french = "fr"
    case german = "de"
    case italian = "it"
    case portuguese = "pt"
    case russian = "ru"
    case chinese = "zh"
    case japanese = "ja"
    case korean = "ko"
    case arabic = "ar"
    case hindi = "hi"
    
    // Additional popular languages
    case dutch = "nl"
    case polish = "pl"
    case turkish = "tr"
    case swedish = "sv"
    case danish = "da"
    case norwegian = "no"
    case finnish = "fi"
    case greek = "el"
    case czech = "cs"
    case hungarian = "hu"
    case romanian = "ro"
    case bulgarian = "bg"
    case ukrainian = "uk"
    case hebrew = "he"
    case thai = "th"
    case vietnamese = "vi"
    case indonesian = "id"
    case malay = "ms"
    
    /// Human-readable name for UI
    var displayName: String {
        switch self {
        case .english: return "English"
        case .spanish: return "Spanish"
        case .french: return "French"
        case .german: return "German"
        case .italian: return "Italian"
        case .portuguese: return "Portuguese"
        case .russian: return "Russian"
        case .chinese: return "Chinese"
        case .japanese: return "Japanese"
        case .korean: return "Korean"
        case .arabic: return "Arabic"
        case .hindi: return "Hindi"
        case .dutch: return "Dutch"
        case .polish: return "Polish"
        case .turkish: return "Turkish"
        case .swedish: return "Swedish"
        case .danish: return "Danish"
        case .norwegian: return "Norwegian"
        case .finnish: return "Finnish"
        case .greek: return "Greek"
        case .czech: return "Czech"
        case .hungarian: return "Hungarian"
        case .romanian: return "Romanian"
        case .bulgarian: return "Bulgarian"
        case .ukrainian: return "Ukrainian"
        case .hebrew: return "Hebrew"
        case .thai: return "Thai"
        case .vietnamese: return "Vietnamese"
        case .indonesian: return "Indonesian"
        case .malay: return "Malay"
        }
    }
    
    /// Visual icon for the language
    var flag: String {
        switch self {
        case .english: return "🇬🇧"
        case .spanish: return "🇪🇸"
        case .french: return "🇫🇷"
        case .german: return "🇩🇪"
        case .italian: return "🇮🇹"
        case .portuguese: return "🇵🇹"
        case .russian: return "🇷🇺"
        case .chinese: return "🇨🇳"
        case .japanese: return "🇯🇵"
        case .korean: return "🇰🇷"
        case .arabic: return "🇸🇦"
        case .hindi: return "🇮🇳"
        case .dutch: return "🇳🇱"
        case .polish: return "🇵🇱"
        case .turkish: return "🇹🇷"
        case .swedish: return "🇸🇪"
        case .danish: return "🇩🇰"
        case .norwegian: return "🇳🇴"
        case .finnish: return "🇫🇮"
        case .greek: return "🇬🇷"
        case .czech: return "🇨🇿"
        case .hungarian: return "🇭🇺"
        case .romanian: return "🇷🇴"
        case .bulgarian: return "🇧🇬"
        case .ukrainian: return "🇺🇦"
        case .hebrew: return "🇮🇱"
        case .thai: return "🇹🇭"
        case .vietnamese: return "🇻🇳"
        case .indonesian: return "🇮🇩"
        case .malay: return "🇲🇾"
        }
    }
}

// MARK: - Language Pair
struct LanguagePair: Codable, Equatable {
    let source: Language
    let target: Language
}
