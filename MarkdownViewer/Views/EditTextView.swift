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
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(title).font(.headline)
            
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
