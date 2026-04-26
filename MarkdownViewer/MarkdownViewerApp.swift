//
//  MarkdownViewerApp.swift
//  MarkdownViewer
//
//  Created by Ringo Wathelet on 2026/04/26.
//

import SwiftUI

@main
struct MarkdownViewerApp: App {
    @State private var textModel = TextModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(textModel)
        }
    }
}
