//
//  TranslatedTextSection.swift
//  TranslateApp
//
//  Created by Aleksandr Meshchenko on 04.09.25.
//

import SwiftUI

// MARK: - Translated Text Section
struct TranslatedTextSection: View {
    @EnvironmentObject var store: AppStore
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            // Layer 1: Background flag
            BackgroundFlagLayer(language: store.state.targetLanguage)
                .opacity(0.5)
            
            // Layer 2: Content
            ContentLayer(
                isLoading: store.state.isLoading,
                error: store.state.error,
                translatedText: store.state.translatedText
            )
            
            // Layer 3: Overlay buttons
            if !store.state.translatedText.isEmpty {
                HStack {
                    Spacer()
                    
                    VStack {
                        Button {
                            store.dispatch(.copyTranslation)
                        } label: {
                            Image(systemName: "doc.on.doc")
                                .font(.system(size: 16))
                                .foregroundColor(.blue)
                                .frame(width: 30, height: 30)
                                .background(Circle().fill(Color(.systemBackground)))
                                .shadow(radius: 1)
                        }
                        
                        Spacer()
                        
                        if store.state.isAudioEnabled {
                            AudioButton(
                                isPlaying: store.state.playingAudio == .target,
                                action: {
                                    store.dispatch(.playTranslatedAudio)
                                }
                            )
                        }
                    }
                    .padding(8)
                }
            }
        }
        .frame(minHeight: 120)
        .background(Color(.systemGray6).opacity(0.5))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(.systemGray3), lineWidth: 1)
        )
        .cornerRadius(10)
    }
}

struct ContentLayer: View {
    let isLoading: Bool
    let error: TranslationError?
    let translatedText: String
    
    var body: some View {
        Group {
            if isLoading {
                HStack {
                    Spacer()
                    VStack(spacing: 8) {
                        ProgressView()
                            .scaleEffect(0.9)
                        Text("Translating...")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    Spacer()
                }
            } else if let error = error {
                VStack(spacing: 8) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 32))
                        .foregroundColor(.orange)
                    Text(error.localizedDescription)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if !translatedText.isEmpty {
                ScrollView {
                    Text(translatedText)
                        .padding()
                        .padding(.trailing, 40) // for buttons
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .textSelection(.enabled)
                }
            } else {
                Text("Translation will appear here...")
                    .foregroundColor(.secondary)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}
