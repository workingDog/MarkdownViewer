//
//  EditableTextPane.swift
//  MarkdownViewer
//
//  Created by Ringo Wathelet on 2026/04/26.
//
import SwiftUI
import UniformTypeIdentifiers



struct EditableTextPane: View {
    let title: String
    @Binding var text: String
    let paneHeight: CGFloat
    
    @State private var fileURL: URL = FileManager.default.temporaryDirectory
    @State private var isTargeted = false
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 12) {
                Text(title).font(.headline)
                
                ZStack {
                    TextEditor(text: $text)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .scrollContentBackground(.hidden)
                        .padding(8)
                        .background(.background, in: RoundedRectangle(cornerRadius: 8))
                    
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.clear)
                        .contentShape(Rectangle())
                        .dropDestination(for: URL.self) { urls, _ in
                            handleDrop(urls: urls)
                        } isTargeted: { hovering in
                            isTargeted = hovering
                        }
                    
                    if isTargeted {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.accentColor.opacity(0.20))
                            .allowsHitTesting(false)
                    }
                }
            }
            .padding()
            .frame(maxWidth: .infinity, minHeight: paneHeight, alignment: .topLeading)
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
            text = try String(contentsOf: fileURL, encoding: .utf8)
        } catch {
            print(error)
        }
    }
    
}

