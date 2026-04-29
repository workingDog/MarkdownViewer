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


enum ViewMode: String, CaseIterable, Hashable {
    case edit = "Edit"
    case split = "Split"
    case preview = "Preview"
}

struct ContentView: View {
    @State private var isExporting = false
    @State private var showSettings = false
    @State private var text: String = ""
  
    @State private var viewMode: ViewMode = .split
    
    @ViewBuilder var splitView: some View {
        HSplitView {
            EditTextView(title: "Edit", text: $text)
                .frame(minWidth: 160, maxWidth: .infinity, maxHeight: .infinity)
            
            MKView(title: "Preview", text: $text)
                .frame(minWidth: 160, maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    var body: some View {
        Group {
            switch viewMode {
                case .edit: EditTextView(title: "Edit", text: $text)
                case .split: splitView
                case .preview: MKView(title: "Preview", text: $text)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .toolbar {
            
            ToolbarItem(placement: .principal) {
                Picker("", selection: $viewMode) {
                    Text("Edit").tag(ViewMode.edit)
                    Text("Split").tag(ViewMode.split)
                    Text("Preview").tag(ViewMode.preview)
                }
                .pickerStyle(.segmented)
                .frame(width: 220)
            }

            ToolbarItem(placement: .confirmationAction) {
                HStack {
                    Button("Save") { isExporting = true }
                        .tint(.accentColor.opacity(0.7))
                    Button { showSettings = true } label: {
                        Image(systemName: "gear").font(.title2)
                    }
                    .tint(.gray.opacity(0.8))
                }
                .buttonStyle(.glass)
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
