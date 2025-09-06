//
//  AudioButton.swift
//  TranslateApp
//
//  Created by Aleksandr Meshchenko on 06.09.25.
//

import SwiftUI

struct AudioButton: View {
    let isPlaying: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: isPlaying ? "speaker.wave.2.fill" : "speaker.wave.2")
                .font(.system(size: 18))
                .foregroundColor(isPlaying ? .blue : .secondary)
                .frame(width: 32, height: 32)
                .background(
                    Circle()
                        .fill(Color(.systemBackground))
                        .shadow(color: isPlaying ? .blue.opacity(0.2) : .gray.opacity(0.15), radius: 2, y: 1)
                )
        }
        .symbolEffect(.bounce, value: isPlaying)
    }
}
