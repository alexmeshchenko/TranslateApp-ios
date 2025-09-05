//
//  TranslationView.swift
//  TranslateApp
//
//  Created by Aleksandr Meshchenko on 04.09.25.
//

import SwiftUI

struct TranslationView: View {
    @EnvironmentObject var store: AppStore
    @FocusState private var isSourceTextFocused: Bool
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Language selector bar
                CompactLanguageBar()
                
                Divider()
                
                ScrollView {
                    VStack(spacing: 16) {
                        // Source text input
                        SourceTextSection()
                        
                        // Action buttons
                        ActionButtonsSection()
                        
                        // Translated text output
                        TranslatedTextSection()
                    }
                    .padding()
                }
            }
            .navigationTitle("Translate")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        // TODO: Show settings
                    } label: {
                        Image(systemName: "gearshape")
                    }
                }
            }
        }
    }
}

// MARK: - Preview
#Preview {
    TranslationView()
        .environmentObject(Store.makeAppStore())
}
