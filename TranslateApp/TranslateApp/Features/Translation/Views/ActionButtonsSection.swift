//
//  ActionButtonsSection.swift
//  TranslateApp
//
//  Created by Aleksandr Meshchenko on 04.09.25.
//

import SwiftUI

struct ActionButtonsSection: View {
    @EnvironmentObject var store: AppStore
    @State private var isPressed = false
    
    var body: some View {
        Button {
            // Animate button press
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isPressed = true
            }
            
            // Haptic feedback
            HapticFeedback.medium()
            
            // Dispatch action
            store.dispatch(.translate)
            
            // Reset button state
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation {
                    isPressed = false
                }
            }
        } label: {
            HStack {
                if store.state.isLoading {
                    ProgressView()
                        .scaleEffect(0.8)
                        .tint(.white)
                        .transition(.scale.combined(with: .opacity))
                } else {
                    Image(systemName: "translate")
                        .symbolEffect(.pulse, value: store.state.isLoading)
                    Text("Translate")
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(store.state.canTranslate ? Color.blue : Color.gray)
                    .shadow(
                        color: store.state.canTranslate ? .blue.opacity(0.3) : .clear,
                        radius: isPressed ? 2 : 6,
                        y: isPressed ? 1 : 3
                    )
            )
            .foregroundColor(.white)
            .scaleEffect(isPressed ? 0.97 : 1.0)
        }
        .disabled(!store.state.canTranslate || store.state.isLoading)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: store.state.canTranslate)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: store.state.isLoading)
    }
}

#Preview {
    ActionButtonsSection()
        .padding()
        .environmentObject(Store.makeAppStore())
}
