//
//  SourceTextSection.swift
//  TranslateApp
//
//  Created by Aleksandr Meshchenko on 04.09.25.
//

import SwiftUI

struct SourceTextSection: View {
    @EnvironmentObject var store: AppStore
    @FocusState private var isFocused: Bool
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            
            // Layer 1: Background flag
            BackgroundFlagLayer(language: store.state.sourceLanguage)
                        
            // SourceText, layer 2:
            TextEditor(text: Binding(
                get: { store.state.sourceText },
                set: { store.dispatch(.updateSourceText($0)) }
            ))
            .focused($isFocused)
            .frame(minHeight: 120)
            .padding(12)
            .scrollContentBackground(.hidden)
            .background(Color(.systemGray6).opacity(0.5))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(
                        isFocused ? Color.blue.opacity(0.3) : Color(.systemGray3),
                        lineWidth: isFocused ? 2 : 1
                    )
            )
            .cornerRadius(10)
            .animation(.easeInOut(duration: 0.2), value: isFocused)
            
            // Layer 3: Placeholder
            if store.state.sourceText.isEmpty && !isFocused {
                PlaceholderLayer()
            }
            
            // Layer 4: Buttons
            ButtonsOverlayLayer(
                sourceText: store.state.sourceText,
                isAudioEnabled: store.state.isAudioEnabled,
                playingAudio: store.state.playingAudio,
                onClear: {
                    store.dispatch(.clearText)
                    isFocused = false
                },
                onPlayAudio: {
                    store.dispatch(.playSourceAudio)
                }
            )        }
        .animation(.easeInOut(duration: 0.2), value: store.state.sourceText.isEmpty)
        .animation(.easeInOut(duration: 0.2), value: store.state.playingAudio)
        .animation(.easeInOut(duration: 0.3), value: store.state.sourceLanguage)
    }
}

struct BackgroundFlagLayer: View {
    let language: Language
    
    var body: some View {
        Text(language.flag)
            .font(.system(size: 120))
            .opacity(0.1)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .scaleEffect(1.5)
            .rotationEffect(.degrees(-10))
    }
}

struct PlaceholderLayer: View {
    var body: some View {
        Text("Enter text to translate...")
            .foregroundColor(.secondary)
            .padding(.horizontal, 16)
            .padding(.vertical, 20)
            .allowsHitTesting(false)
    }
}

struct ButtonsOverlayLayer: View {
    let sourceText: String
    let isAudioEnabled: Bool
    let playingAudio: AudioPlayback?
    let onClear: () -> Void
    let onPlayAudio: () -> Void
    
    var body: some View {
        HStack {
            Spacer()
            
            VStack {
                if !sourceText.isEmpty {
                    ClearButton(action: onClear)
                        .transition(.scale.combined(with: .opacity))
                }
                
                Spacer()
                
                if isAudioEnabled && !sourceText.isEmpty {
                    AudioButton(
                        isPlaying: playingAudio == .source,
                        action: onPlayAudio
                    )
                    .transition(.scale.combined(with: .opacity))
                }
            }
            .padding(8)
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        Text("Standard Design")
            .font(.headline)
        SourceTextSection()
        
    }
    .padding()
    .environmentObject(Store.makeAppStore())
}
