//
//  ClearButton.swift
//  TranslateApp
//
//  Created by Aleksandr Meshchenko on 06.09.25.
//

import SwiftUI

// MARK: - Clear Button
struct ClearButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "xmark.circle.fill")
                .foregroundColor(.secondary.opacity(0.6))
                .frame(width: 32, height: 32)
        }
    }
}
