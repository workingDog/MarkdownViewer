//
//  MKView.swift
//  MarkdownViewer
//
//  Created by Ringo Wathelet on 2026/04/26.
//
import SwiftUI
import Textual


struct MKView: View {
    @Environment(TextModel.self) private var textModel

    let title: String
//    @State private var attributed = AttributedString()

    @State private var refreshID = UUID()
    @State private var refreshTask: Task<Void, Never>?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text(title).font(.headline)
//                Text(attributed)

                StructuredText(markdown: textModel.text)
                    .id(refreshID)
                    .textual.textSelection(.enabled)
                    .textual.structuredTextStyle(.gitHub)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .topLeading)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(.background.secondary, in: RoundedRectangle(cornerRadius: 12))
        .task {
//            do {
//                attributed = try AttributedString(markdown: textModel.text)
//            } catch {
//                print(error)
//            }
            refreshID = UUID()
        }
        .onChange(of: textModel.text, initial: false) { _, _ in
            refreshTask?.cancel()
            refreshTask = Task {
                try? await Task.sleep(for: .milliseconds(250))
                guard !Task.isCancelled else { return }
                refreshID = UUID()
            }
        }
    }
}
