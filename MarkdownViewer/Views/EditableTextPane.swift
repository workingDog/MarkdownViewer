//
//  EditableTextPane.swift
//  MarkdownViewer
//
//  Created by Ringo Wathelet on 2026/04/26.
//
import SwiftUI

struct EditableTextPane: View {
    let title: String
    @Binding var text: String
    let paneHeight: CGFloat

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title).font(.headline)

            TextEditor(text: $text)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .scrollContentBackground(.hidden)
                .padding(8)
                .background(.background, in: RoundedRectangle(cornerRadius: 8))
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: paneHeight, alignment: .topLeading)
        .background(.quaternary, in: RoundedRectangle(cornerRadius: 12))
    }
}
