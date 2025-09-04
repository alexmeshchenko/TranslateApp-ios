//
//  TranslateApp.swift
//  TranslateApp
//
//  Created by Aleksandr Meshchenko on 03.09.25.
//

import SwiftUI

@main
struct TranslateApp: App {
    // Create the main store
    @StateObject private var store = Store.makeAppStore()
    
    var body: some Scene {
        WindowGroup {
            TranslationView()
                .environmentObject(store)
                .onAppear {
                    // Load saved preferences when app starts
                    store.dispatch(.appDidBecomeActive)
                }
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                    // Save preferences when app goes to background
                    store.dispatch(.appWillResignActive)
                }
        }
    }
}
