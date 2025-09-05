//
//  LanguageMenu.swift
//  TranslateApp
//
//  Created by Aleksandr Meshchenko on 05.09.25.
//

import SwiftUI

struct LanguageMenu: View {
    @EnvironmentObject private var store: AppStore
    let isSourceLanguage: Bool
    
    private var currentLanguage: Language {
        isSourceLanguage ? store.state.sourceLanguage : store.state.targetLanguage
    }
    
    private var sortedLanguages: [Language] {
        let favorites = store.state.favoriteLanguages.sorted { $0.displayName < $1.displayName }
        let others = Language.allCases
            .filter { !store.state.favoriteLanguages.contains($0) }
            .sorted { $0.displayName < $1.displayName }
        return favorites + others
    }
    
    var body: some View {
        Menu {
            // Favorites section
            if !store.state.favoriteLanguages.isEmpty {
                Section("Favorites") {
                    ForEach(store.state.favoriteLanguages.sorted { $0.displayName < $1.displayName }, id: \.self) { language in
                        Button {
                            selectLanguage(language)
                        } label: {
                            Label {
                                HStack {
                                    Text("\(language.flag) \(language.displayName)")
                                    if language == currentLanguage {
                                        Image(systemName: "checkmark")
                                    }
                                }
                            } icon: {
                                Text(language.flag)
                            }
                        }
                    }
                }
                
                Divider()
            }
            
            // All languages section
            Section(store.state.favoriteLanguages.isEmpty ? "" : "All Languages") {
                ForEach(Language.allCases.filter { !store.state.favoriteLanguages.contains($0) }, id: \.self) { language in
                    Button {
                        selectLanguage(language)
                    } label: {
                        Label {
                            HStack {
                                Text("\(language.flag) \(language.displayName)")
                                if language == currentLanguage {
                                    Image(systemName: "checkmark")
                                }
                            }
                        } icon: {
                            Text(language.flag)
                        }
                    }
                }
            }
            
            Divider()
            
            // Manage favorites
            Menu("Manage Favorites") {
                ForEach(Language.allCases, id: \.self) { language in
                    Button {
                        store.dispatch(.toggleFavoriteLanguage(language))
                        HapticFeedback.light()
                    } label: {
                        Label {
                            Text("\(language.flag) \(language.displayName)")
                        } icon: {
                            Image(systemName: store.state.favoriteLanguages.contains(language) ? "star.fill" : "star")
                                .foregroundColor(store.state.favoriteLanguages.contains(language) ? .yellow : .gray)
                        }
                    }
                }
            }
        } label: {
            HStack(spacing: 4) {
                Text(currentLanguage.flag)
                Text(currentLanguage.displayName)
                    .lineLimit(1)
                Image(systemName: "chevron.down")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .contentShape(Rectangle())
        }
        .transaction { transaction in
            transaction.animation = .spring(response: 0.3, dampingFraction: 0.8)
        }
    }
    
    private func selectLanguage(_ language: Language) {
        HapticFeedback.selection()
        
        if isSourceLanguage {
            store.dispatch(.selectSourceLanguage(language))
        } else {
            store.dispatch(.selectTargetLanguage(language))
        }
    }
}
