//
//  MarkdownViewerApp.swift
//  MarkdownViewer
//
//  Created by Ringo Wathelet on 2026/04/26.
//

import SwiftUI

enum AppTheme {
    static let backGradient = LinearGradient(
        colors: [
            Color.green.opacity(0.3),
            Color.blue.opacity(0.2),
            Color.red.opacity(0.1)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

@main
struct MarkdownViewerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
