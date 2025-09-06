//
//  SettingsView.swift
//  TranslateApp
//
//  Created by Aleksandr Meshchenko on 06.09.25.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var store: AppStore

    private var autoTranslateBinding: Binding<Bool> {
        Binding(
            get: { store.state.isAutoTranslateEnabled },
            set: { store.dispatch(.setAutoTranslate($0)) }
        )
    }

    private var audioBinding: Binding<Bool> {
        Binding(
            get: { store.state.isAudioEnabled },
            set: { _ in store.dispatch(.toggleAudioFeature) } // у тебя уже есть toggleAudioFeature
        )
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Translation") {
                    Toggle("Auto-translate", isOn: autoTranslateBinding)
                }
                Section("Audio") {
                    Toggle("Enable audio", isOn: audioBinding)
                }
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { store.dispatch(.setSettingsPresented(false)) }
                }
            }
        }
    }
}
