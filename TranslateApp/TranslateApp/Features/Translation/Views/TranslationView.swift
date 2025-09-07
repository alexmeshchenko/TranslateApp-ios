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
                        store.dispatch(.setSettingsPresented(true))
                    } label: {
                        Image(systemName: "gearshape")
                    }
                }
            }
            .sheet(isPresented: Binding(
                get: { store.state.isSettingsPresented },
                set: { store.dispatch(.setSettingsPresented($0)) }
            )) {
                SettingsView().environmentObject(store)
            }
            .task {
                // Upload saved custom settings once
                store.dispatch(.loadUserPreferences)
            }
            
            
        }
    }
}

// MARK: - Preview
#Preview {
    TranslationView()
        .environmentObject(Store.makeAppStore())
}
