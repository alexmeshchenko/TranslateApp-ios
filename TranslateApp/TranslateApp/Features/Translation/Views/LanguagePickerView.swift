//
//  LanguagePickerView.swift
//  TranslateApp
//
//  Created by Aleksandr Meshchenko on 04.09.25.
//

import SwiftUI

// MARK: - Language Picker (Temporary)
struct LanguagePickerView: View {
    let selectedLanguage: Language
    let onSelect: (Language) -> Void
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            List(Language.allCases, id: \.self) { language in
                Button {
                    onSelect(language)
                    dismiss()
                } label: {
                    HStack {
                        Text(language.flag)
                            .font(.title2)
                        Text(language.displayName)
                        Spacer()
                        if language == selectedLanguage {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(.vertical, 4)
                }
                .buttonStyle(.plain)
            }
            .navigationTitle("Select Language")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}
