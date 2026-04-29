//
//  DropFileView.swift
//  MarkdownViewer
//
//  Created by Ringo Wathelet on 2026/04/29.
//
import SwiftUI
import UniformTypeIdentifiers


struct DropFileView: View {
    @Binding var text: String
    
    @State private var fileURL: URL = FileManager.default.temporaryDirectory
    @State private var showTextImporter = false
    @State private var isTargeted = false
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color.green.opacity(0.3))
            
            VStack(spacing: 5) {
                Text("Drop File here")
                Text("or")
                Button("Browse for File") {
                    showTextImporter = true
                }
                .foregroundColor(.accentColor)
            }
        }
        .frame(height: 80)
        .padding(8)
        .contentShape(Rectangle())
        .overlay {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color.accentColor.opacity(isTargeted ? 0.2 : 0))
        }
        .dropDestination(for: URL.self) { urls, _ in
            handleDrop(urls: urls)
        } isTargeted: { hovering in
            isTargeted = hovering
        }
        .fileImporter(
            isPresented: $showTextImporter,
            allowedContentTypes: [.item],
            allowsMultipleSelection: false
        ) { result in
            switch result {
            case .success(let urls):
                if let file = urls.first {
                    fileURL = file
                    readFileContent()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func handleDrop(urls: [URL]) -> Bool {
        guard let url = urls.first, url.isFileURL else { return false }
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
