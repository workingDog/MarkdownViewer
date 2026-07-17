//
//  EditTextView.swift
//  MarkdownViewer
//
//  Created by Ringo Wathelet on 2026/04/26.
//
import SwiftUI
import UniformTypeIdentifiers


struct EditTextView: View {
    @AppStorage("fontSize") private var fontSize = 20.0
    
    let title: String
    @Binding var text: String
    @Binding var fileURL: URL?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text(title).font(.headline)
                Button("Save") {
                    if let fileURL {
                        Utility.writeFileContent(text: text, fileURL: fileURL)
                    }
                }.buttonStyle(.glass)
                Spacer()
                Text({
                    guard let fileURL else { return "" }
                    let isDirectory = (try? fileURL.resourceValues(forKeys: [.isDirectoryKey]))?.isDirectory ?? false
                    return isDirectory ? "" : fileURL.lastPathComponent
                }())
            }.frame(maxWidth: .infinity)

            TextEditor(text: $text)
#if os(iOS) || os(visionOS)
                .textInputAutocapitalization(.none)
#endif
                .font(.system(size: fontSize))
                .autocorrectionDisabled(true)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .scrollContentBackground(.hidden)
                .padding(4)
                .background(.background, in: RoundedRectangle(cornerRadius: 8))
        }
        .padding(8)
        .background(.quaternary, in: RoundedRectangle(cornerRadius: 12))
    }
    
}
