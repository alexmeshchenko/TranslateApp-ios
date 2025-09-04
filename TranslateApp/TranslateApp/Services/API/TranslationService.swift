//
//  TranslationService.swift
//  TranslateApp
//
//  Created by Aleksandr Meshchenko on 05.09.25.
//

import Foundation

// MARK: - Translation Service
actor TranslationService {
    static let shared = TranslationService()
    
    private let baseURL = "https://ftapi.pythonanywhere.com"
    private let session: URLSession
    
    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 30
        self.session = URLSession(configuration: config)
    }
    
    /// Translate text from source to target language
    func translate(
        text: String,
        from source: Language,
        to target: Language
    ) async throws -> String {
        // Validate input
        guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw TranslationError.emptyInput
        }
        
        // Build URL with query parameters (GET request)
        var components = URLComponents(string: "\(baseURL)/translate")!
        components.queryItems = [
            URLQueryItem(name: "sl", value: source.rawValue),
            URLQueryItem(name: "dl", value: target.rawValue),
            URLQueryItem(name: "text", value: text)
        ]
        
        guard let url = components.url else {
            throw TranslationError.apiError("Failed to build URL")
        }
        
        print("📤 Sending translation request:")
        print("   URL: \(url)")
        
        // Create GET request
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // Make request
        let (data, response) = try await session.data(for: request)
        
        // Check response
        guard let httpResponse = response as? HTTPURLResponse else {
            throw TranslationError.invalidResponse
        }
        
        print("📊 Status code: \(httpResponse.statusCode)")
        
        switch httpResponse.statusCode {
        case 200:
            // Parse the response based on the documented format
            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                print("📥 Response structure: \(json.keys)")
                
                // Extract destination-text from the response
                if let destinationText = json["destination-text"] as? String {
                    print("✅ Translation: \(destinationText)")
                    return destinationText
                }
                
                print("⚠️ Could not find destination-text in response")
            }
            
            throw TranslationError.invalidResponse
            
        case 403:
            throw TranslationError.apiError("Access forbidden")
            
        case 429:
            throw TranslationError.rateLimitExceeded
            
        case 400...499:
            throw TranslationError.apiError("Invalid request (Status: \(httpResponse.statusCode))")
            
        case 500...599:
            throw TranslationError.apiError("Server error")
            
        default:
            throw TranslationError.apiError("Unexpected status: \(httpResponse.statusCode)")
        }
    }
    
    /// Get list of supported languages
    func getSupportedLanguages() async throws -> [Language] {
        let url = URL(string: "\(baseURL)/languages")!
        
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw TranslationError.invalidResponse
        }
        
        // For now, return our predefined languages
        // The API might not have a languages endpoint
        return Language.allCases
    }
}
