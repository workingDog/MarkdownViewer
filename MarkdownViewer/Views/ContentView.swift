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


struct ContentView: View {
    @State private var isExporting = false
    @State private var showSettings = false
    @State private var text: String = ""
  
    
    var body: some View {
        HSplitView {
            EditTextView(title: "Plain text", text: $text)
                .frame(minWidth: 160, maxWidth: .infinity, maxHeight: .infinity)
            
            MKView(title: "Markdown", text: $text)
                .frame(minWidth: 160, maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Button("Save") {
                    isExporting = true
                }
                .buttonStyle(.glass)
                .tint(.accentColor.opacity(0.8))
            }
            ToolbarItem(placement: .confirmationAction) {
                Button {
                    showSettings = true
                } label: {
                    Image(systemName: "gear").font(.title2)
                }
                .buttonStyle(.glass)
                .tint(.gray.opacity(0.8))
            }
        }
        .fileExporter(
            isPresented: $isExporting,
            document: TextDocument(text: text),
            contentType: .plainText,
            defaultFilename: "Untitled"
        ) { result in
            switch result {
                case .success(let url): print("---> saved to \(url)")
                case .failure(let error): print("---> save error: \(error)")
            }
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
    }
}

struct TextDocument: FileDocument {
    static var readableContentTypes: [UTType] { [.plainText] }
    static var writableContentTypes: [UTType] { [.plainText] }

    var text: String

    init(text: String = "") {
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
