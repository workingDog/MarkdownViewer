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
    @State private var text: String = ""
    
    @State private var isExporting = false
    @State private var showSettings = false
    @State private var viewMode: ViewMode = .split
    
    @ViewBuilder
    private var mainView: some View {
        switch viewMode {
        case .edit:
            editorView
            
        case .split:
            HSplitView {
                editorView
                previewView
            }
            
        case .preview:
            previewView
        }
    }
    
    private var editorView: some View {
        EditTextView(title: "Edit", text: $text)
            .frame(minWidth: 160, maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var previewView: some View {
        MKView(title: "Preview", text: $text)
            .frame(minWidth: 160, maxWidth: .infinity, maxHeight: .infinity)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            DropFileView(text: $text)
            mainView
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
                    Button { isExporting = true } label: {
                        Image(systemName: "square.and.arrow.up").font(.title2)
                    }
                    .help("Export")
                    .accessibilityLabel("Export")
                    
                    Button { showSettings = true } label: {
                        Image(systemName: "gear").font(.title2)
                    }
                    .help("Settings")
                    .accessibilityLabel("Settings")
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
