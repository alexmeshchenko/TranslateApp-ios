//
//  SourceTextSection.swift
//  TranslateApp
//
//  Created by Aleksandr Meshchenko on 04.09.25.
//

import SwiftUI

// MARK: - Source Text Section
struct SourceTextSection: View {
    @EnvironmentObject var store: AppStore
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Label("Source Text", systemImage: "text.alignleft")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                if !store.state.sourceText.isEmpty {
                    Text("\(store.state.sourceText.count) characters")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            
            ZStack(alignment: .topLeading) {
                TextEditor(text: Binding(
                    get: { store.state.sourceText },
                    set: { store.dispatch(.updateSourceText($0)) }
                ))
                .focused($isFocused)
                .frame(minHeight: 120)
                .padding(8)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(.systemGray4), lineWidth: 1)
                )
                
                if store.state.sourceText.isEmpty && !isFocused {
                    Text("Enter text to translate...")
                        .foregroundColor(.secondary)
                        .padding(12)
                        .allowsHitTesting(false)
                }
            }
            
            // Clear button
            if !store.state.sourceText.isEmpty {
                Button {
                    store.dispatch(.clearText)
                } label: {
                    Label("Clear", systemImage: "xmark.circle.fill")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}
