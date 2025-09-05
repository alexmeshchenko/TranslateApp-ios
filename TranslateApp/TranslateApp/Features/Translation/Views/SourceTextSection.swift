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
        ZStack(alignment: .topTrailing) {
            // Text Editor with placeholder
            ZStack(alignment: .topLeading) {
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
            }
            
            // Clear button overlay
            if !store.state.sourceText.isEmpty {
                Button {
                    store.dispatch(.clearText)
                    isFocused = false
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 18))
                        .foregroundColor(.secondary.opacity(0.6))
                        .background(Circle().fill(Color(.systemBackground)))
                }
                .padding(8)
                .transition(.scale.combined(with: .opacity))
            }
        }
        .animation(.easeInOut(duration: 0.2), value: store.state.sourceText.isEmpty)
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
