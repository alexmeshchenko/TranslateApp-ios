//
//  HapticFeedback.swift
//  TranslateApp
//
//  Created by Aleksandr Meshchenko on 05.09.25.
//

import SwiftUI
#if os(iOS)
import UIKit
#endif

// MARK: - Haptic Feedback Helper
enum HapticFeedback {
    
    /// Light impact feedback
    static func light() {
        #if os(iOS)
        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.prepare()
        impact.impactOccurred()
        #endif
    }
    
    /// Medium impact feedback
    static func medium() {
        #if os(iOS)
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.prepare()
        impact.impactOccurred()
        #endif
    }
    
    /// Heavy impact feedback
    static func heavy() {
        #if os(iOS)
        let impact = UIImpactFeedbackGenerator(style: .heavy)
        impact.prepare()
        impact.impactOccurred()
        #endif
    }
    
    /// Success notification feedback
    static func success() {
        #if os(iOS)
        let notification = UINotificationFeedbackGenerator()
        notification.prepare()
        notification.notificationOccurred(.success)
        #endif
    }
    
    /// Warning notification feedback
    static func warning() {
        #if os(iOS)
        let notification = UINotificationFeedbackGenerator()
        notification.prepare()
        notification.notificationOccurred(.warning)
        #endif
    }
    
    /// Error notification feedback
    static func error() {
        #if os(iOS)
        let notification = UINotificationFeedbackGenerator()
        notification.prepare()
        notification.notificationOccurred(.error)
        #endif
    }
    
    /// Selection changed feedback
    static func selection() {
        #if os(iOS)
        let selection = UISelectionFeedbackGenerator()
        selection.prepare()
        selection.selectionChanged()
        #endif
    }
}
