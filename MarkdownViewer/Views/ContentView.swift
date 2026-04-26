//
//  ContentView.swift
//  MarkdownViewer
//
//  Created by Ringo Wathelet on 2026/04/26.
//
import SwiftUI
import UniformTypeIdentifiers
#if os(macOS)
import AppKit
#endif

import SwiftUI

struct ContentView: View {
    @Environment(TextModel.self) private var textModel
    @State private var isExporting = false
    
    @State private var previewTask: Task<Void, Never>?
    
    var body: some View {
        HSplitView {
            EditableTextPane(title: "Plain text")
                .frame(minWidth: 160, maxWidth: .infinity, maxHeight: .infinity)
            
            MKView(title: "Markdown")
                .frame(minWidth: 160, maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(24)
        .toolbar {
            ToolbarItem {
                Button("Save") {
                    isExporting = true
                }
                .buttonStyle(.glass)
                .tint(.accentColor)
            }
        }
        .fileExporter(
            isPresented: $isExporting,
            document: TextDocument(text: textModel.text),
            contentType: .text,
            defaultFilename: "Untitled"
        ) { result in
            switch result {
            case .success(let url):
                print("---> saved to \(url)")
            case .failure(let error):
                print("---> save error: \(error)")
            }
        }
    }
}

struct TextDocument: FileDocument {
    static var readableContentTypes: [UTType] { [.plainText] }
    
    var text: String
    
    init(text: String) {
        self.text = text
    }
    
    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents,
              let text = String(data: data, encoding: .utf8) else {
            throw CocoaError(.fileReadCorruptFile)
        }
        self.text = text
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        FileWrapper(regularFileWithContents: Data(text.utf8))
    }
}
