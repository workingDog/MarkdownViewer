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
    
    // hack to refresh StructuredText
    @State private var refreshID = UUID()
    @State private var refreshTask: Task<Void, Never>?
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text(title).font(.headline)
                
                StructuredText(markdown: text)
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
            refreshID = UUID()
        }
        .onChange(of: text, initial: false) { _, _ in
            refreshTask?.cancel()
            refreshTask = Task {
                try? await Task.sleep(for: .milliseconds(250))
                guard !Task.isCancelled else { return }
                refreshID = UUID()
            }
        }
    }
}
