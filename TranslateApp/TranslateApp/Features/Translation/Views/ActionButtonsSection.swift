//
//  ActionButtonsSection.swift
//  TranslateApp
//
//  Created by Aleksandr Meshchenko on 04.09.25.
//

import SwiftUI

// MARK: - Action Buttons
struct ActionButtonsSection: View {
    @EnvironmentObject var store: AppStore
    
    var body: some View {
        HStack(spacing: 12) {
            // Translate button
            Button {
                store.dispatch(.translate)
            } label: {
                HStack {
                    if store.state.isLoading {
                        ProgressView()
                            .scaleEffect(0.8)
                            .tint(.white)
                    } else {
                        Image(systemName: "translate")
                        Text("Translate")
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(store.state.canTranslate ? Color.blue : Color.gray)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            .disabled(!store.state.canTranslate || store.state.isLoading)
            
            // Audio button (if enabled)
            if store.state.isAudioEnabled && !store.state.sourceText.isEmpty {
                Button {
                    store.dispatch(.playSourceAudio)
                } label: {
                    Image(systemName: store.state.playingAudio == .source ? "speaker.wave.2.fill" : "speaker.wave.2")
                        .frame(width: 44, height: 44)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                }
            }
        }
    }
}
