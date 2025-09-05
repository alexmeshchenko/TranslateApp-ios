//
//  CompactLanguageBar.swift
//  TranslateApp
//
//  Created by Aleksandr Meshchenko on 05.09.25.
//

import SwiftUI

struct CompactLanguageBar: View {
    @EnvironmentObject var store: AppStore
    @State private var swapRotation: Double = 0
    
    var body: some View {
        HStack(spacing: 0) {
            // Source language
            LanguageMenu(isSourceLanguage: true)
                .environmentObject(store)
               
            Spacer()
            
            // Swap button
            Button {
                HapticFeedback.medium()
                withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                    swapRotation += 180
                }
                store.dispatch(.swapLanguages)
            } label: {
                Image(systemName: "arrow.left.arrow.right")
                    .font(.system(size: 16, weight: .semibold))
                    .rotationEffect(.degrees(swapRotation))
                    .foregroundColor(store.state.canSwapLanguages ? .blue : .secondary)
                    .frame(width: 44, height: 44)
                    .background(
                        Circle()
                            .fill(Color(.systemBackground))
                            .shadow(color: .gray.opacity(0.15), radius: 3, y: 1)
                    )
            }
            .disabled(!store.state.canSwapLanguages)
            
            Spacer()
            
            // Target language
            LanguageMenu(isSourceLanguage: false)
                .environmentObject(store)
        }
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color(.systemGray6))
                .shadow(color: .gray.opacity(0.1), radius: 2, y: 1)
        )
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
}

#Preview {
    CompactLanguageBar()
        .environmentObject(Store.makeAppStore())
}
