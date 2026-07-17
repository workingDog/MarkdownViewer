//
//  MarkdownViewerApp.swift
//  MarkdownViewer
//
//  Created by Ringo Wathelet on 2026/04/26.
//

import SwiftUI
import UniformTypeIdentifiers


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
    @State private var text: String = ""
    @State private var fileURL: URL?
    
    var body: some Scene {
        Window("Markdown Viewer", id: "main") {
            ContentView(text: $text, fileURL: $fileURL)
                .onOpenURL { url in
                    fileURL = url
                    text = Utility.readFileContent(fileURL: url)
                }
        }
    }
}
