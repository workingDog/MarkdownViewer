//
//  MKView.swift
//  MarkdownViewer
//
//  Created by Ringo Wathelet on 2026/04/26.
//
import SwiftUI
import Textual


struct MKView: View {
    let title: String
    @Binding var text: String

    @State private var displayedText = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title).font(.headline)
            ScrollView {
                StructuredText(markdown: displayedText, syntaxExtensions: [.math])
                    .textual.textSelection(.enabled)
                    .textual.structuredTextStyle(.gitHub)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .topLeading)
        }
        .padding(8)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(.background.secondary, in: RoundedRectangle(cornerRadius: 12))
        .task(id: text) {
            // debounce rapid edits
            try? await Task.sleep(for: .milliseconds(200))
            guard !Task.isCancelled else { return }
            displayedText = text
        }
        .onAppear {
            displayedText = text
        }
    }
}
