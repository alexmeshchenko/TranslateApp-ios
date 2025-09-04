//
//  LanguageBarView.swift
//  TranslateApp
//
//  Created by Aleksandr Meshchenko on 04.09.25.
//

import SwiftUI

// MARK: - Language Bar
struct LanguageBarView: View {
    @EnvironmentObject var store: AppStore
    
    var body: some View {
        HStack(spacing: 0) {
            // Source language button
            Button {
                store.dispatch(.toggleSourceLanguagePicker)
            } label: {
                HStack {
                    Text(store.state.sourceLanguage.flag)
                    Text(store.state.sourceLanguage.displayName)
                        .lineLimit(1)
                    Image(systemName: "chevron.down")
                        .font(.caption)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
            }
            
            // Swap button
            Button {
                store.dispatch(.swapLanguages)
            } label: {
                Image(systemName: "arrow.left.arrow.right")
                    .font(.system(size: 16, weight: .semibold))
                    .frame(width: 44, height: 44)
            }
            .disabled(!store.state.canSwapLanguages)
            
            // Target language button
            Button {
                store.dispatch(.toggleTargetLanguagePicker)
            } label: {
                HStack {
                    Text(store.state.targetLanguage.flag)
                    Text(store.state.targetLanguage.displayName)
                        .lineLimit(1)
                    Image(systemName: "chevron.down")
                        .font(.caption)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
            }
        }
        .font(.system(size: 15, weight: .medium))
        .background(Color(.systemGray6))
        .sheet(isPresented: .constant(store.state.isShowingSourceLanguagePicker)) {
            LanguagePickerView(
                selectedLanguage: store.state.sourceLanguage,
                onSelect: { language in
                    store.dispatch(.selectSourceLanguage(language))
                }
            )
        }
        .sheet(isPresented: .constant(store.state.isShowingTargetLanguagePicker)) {
            LanguagePickerView(
                selectedLanguage: store.state.targetLanguage,
                onSelect: { language in
                    store.dispatch(.selectTargetLanguage(language))
                }
            )
        }
    }
}
