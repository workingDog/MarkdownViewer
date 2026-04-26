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
    let paneHeight: CGFloat

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text(title).font(.headline)
              //  InlineText(markdown: text)
                StructuredText(markdown: text)
                    .textual.textSelection(.enabled)
                    .textual.structuredTextStyle(.gitHub)
                    .id(text) // <-- force a refresh
            }
            .padding()
            .frame(maxWidth: .infinity, minHeight: paneHeight, alignment: .topLeading)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(.background.secondary, in: RoundedRectangle(cornerRadius: 12))
    }
}

