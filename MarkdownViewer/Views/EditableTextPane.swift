//
//  EditableTextPane.swift
//  MarkdownViewer
//
//  Created by Ringo Wathelet on 2026/04/26.
//
import SwiftUI
import UniformTypeIdentifiers


struct EditableTextPane: View {
    @Environment(TextModel.self) private var textModel
    
    let title: String
    
    @State private var fileURL: URL = FileManager.default.temporaryDirectory
    @State private var isTargeted = false
    
    var body: some View {
        @Bindable var textModel = textModel
        ZStack {
            VStack(alignment: .leading, spacing: 12) {
                Text(title).font(.headline)
                
                RoundedRectangle(cornerRadius: 8)
                    .fill(isTargeted ? Color.accentColor.opacity(0.2) : Color.green.opacity(0.3))
                    .frame(height: 50)
                    .overlay {
                        Text("Drop file area").foregroundStyle(.secondary)
                    }
                    .dropDestination(for: URL.self) { urls, _ in
                        handleDrop(urls: urls)
                    } isTargeted: { hovering in
                        isTargeted = hovering
                    }
                
                TextEditor(text: $textModel.text)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .scrollContentBackground(.hidden)
                    .padding(8)
                    .background(.background, in: RoundedRectangle(cornerRadius: 8))
            }
            .padding()
            .background(.quaternary, in: RoundedRectangle(cornerRadius: 12))
        }
        .overlay {
            Rectangle().fill(Color.accentColor.opacity(isTargeted ? 0.2 : 0))
        }
    }
    
    private func handleDrop(urls: [URL]) -> Bool {
        guard let url = urls.first else { return false }
        guard url.isFileURL else { return false }
        fileURL = url
        readFileContent()
        return true
    }
    
    private func readFileContent() {
        let didStartAccessing = fileURL.startAccessingSecurityScopedResource()
        defer {
            if didStartAccessing {
                fileURL.stopAccessingSecurityScopedResource()
            }
        }
        do {
            textModel.text = try String(contentsOf: fileURL, encoding: .utf8)
        } catch {
            print(error)
        }
    }
    
}
