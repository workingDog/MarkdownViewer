//
//  EditTextView.swift
//  MarkdownViewer
//
//  Created by Ringo Wathelet on 2026/04/26.
//
import SwiftUI
import UniformTypeIdentifiers


struct EditTextView: View {
    let title: String
    @Binding var text: String
    
    @State private var fileURL: URL = FileManager.default.temporaryDirectory
    @State private var showTextImporter = false
    @State private var isTargeted = false
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 15) {
                Text(title).font(.headline)
                
                ZStack {
                    Color.green.opacity(0.3).ignoresSafeArea()
                    VStack(spacing: 5) {
                        Text("Drop File here")
                        Text("or")
                        Button("Browse for File") {
                            showTextImporter = true
                        }
                        .foregroundColor(.accentColor)
                    }
                    .dropDestination(for: URL.self) { urls, _ in
                        handleDrop(urls: urls)
                    } isTargeted: { hovering in
                        isTargeted = hovering
                    }
                }
                .frame(height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))

                TextEditor(text: $text)
                    #if os(iOS) || os(visionOS)
                      .textInputAutocapitalization(.none)
                    #endif
                    .autocorrectionDisabled(true)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .scrollContentBackground(.hidden)
                    .padding(4)
                    .background(.background, in: RoundedRectangle(cornerRadius: 8))
            }
            .padding()
            .background(.quaternary, in: RoundedRectangle(cornerRadius: 12))
        }
        .overlay {
            Rectangle().fill(Color.accentColor.opacity(isTargeted ? 0.2 : 0))
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
