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
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Label("Translation", systemImage: "text.alignright")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                if !store.state.translatedText.isEmpty {
                    // Copy button
                    Button {
                        store.dispatch(.copyTranslation)
                    } label: {
                        Label("Copy", systemImage: "doc.on.doc")
                            .font(.caption)
                    }
                    
                    // Audio button
                    if store.state.isAudioEnabled {
                        Button {
                            store.dispatch(.playTranslatedAudio)
                        } label: {
                            Image(systemName: store.state.playingAudio == .target ? "speaker.wave.2.fill" : "speaker.wave.2")
                                .font(.caption)
                        }
                    }
                }
            }
            
            // Translation result
            ZStack(alignment: .topLeading) {
                if store.state.isLoading {
                    HStack {
                        Spacer()
                        VStack {
                            ProgressView()
                            Text("Translating...")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        Spacer()
                    }
                    .frame(minHeight: 120)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                } else if let error = store.state.error {
                    VStack {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.largeTitle)
                            .foregroundColor(.orange)
                        Text(error.localizedDescription)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(minHeight: 120)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                } else if !store.state.translatedText.isEmpty {
                    Text(store.state.translatedText)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(minHeight: 120)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .textSelection(.enabled)
                } else {
                    Text("Translation will appear here...")
                        .foregroundColor(.secondary)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(minHeight: 120)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                }
            }
        }
    }
}
