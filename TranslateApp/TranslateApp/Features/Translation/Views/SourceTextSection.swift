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
            // Text Editor with placeholder
            TextEditor(text: Binding(
                get: { store.state.sourceText },
                set: { store.dispatch(.updateSourceText($0)) }
            ))
            .focused($isFocused)
            .frame(minHeight: 120)
            .padding(12)
            .scrollContentBackground(.hidden)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            
            // Placeholder
            if store.state.sourceText.isEmpty && !isFocused {
                Text("Enter text to translate...")
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 20)
                    .allowsHitTesting(false)
            }
            
            // Overlay buttons
            HStack {
                Spacer()
                
                VStack {
                    // Clear button at top
                    if !store.state.sourceText.isEmpty {
                        ClearButton {
                            store.dispatch(.clearText)
                            isFocused = false
                        }
                        .transition(.scale.combined(with: .opacity))
                    }
                    
                    Spacer()
                    
                    // Audio button at bottom
                    if store.state.isAudioEnabled && !store.state.sourceText.isEmpty {
                        AudioButton(
                            isPlaying: store.state.playingAudio == .source,
                            action: {
                                store.dispatch(.playSourceAudio)
                            }
                        )
                        .transition(.scale.combined(with: .opacity))
                    }
                }
                .padding(8)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: store.state.sourceText.isEmpty)
        .animation(.easeInOut(duration: 0.2), value: store.state.playingAudio)
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
