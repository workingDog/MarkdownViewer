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
    
    var body: some Scene {
        Window("Markdown Viewer", id: "main") {
            ContentView(text: $text)
                .onOpenURL { url in
                    readFileContent(url: url)
                }
        }
    }

    private func readFileContent(url: URL) {
        let didStartAccessing = url.startAccessingSecurityScopedResource()
        defer {
            if didStartAccessing {
                url.stopAccessingSecurityScopedResource()
            }
        }
        
        do {
            text = try String(contentsOf: url, encoding: .utf8)
        } catch {
            print(error)
        }
    }
    
}
