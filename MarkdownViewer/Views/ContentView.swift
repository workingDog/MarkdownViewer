//
//  ContentView.swift
//  MarkdownViewer
//
//  Created by Ringo Wathelet on 2026/04/26.
//
import SwiftUI
import UniformTypeIdentifiers
#if os(macOS)
import AppKit
#endif


struct ContentView: View {
    @Environment(TextModel.self) private var textModel
    
    @State private var splitRatio: CGFloat = 0.5
    @State private var isExporting = false

    private let minPaneWidth: CGFloat = 160
    private let dividerWidth: CGFloat = 12
    private let outerPadding: CGFloat = 24

    var body: some View {
        GeometryReader { proxy in
            let contentWidth = proxy.size.width - outerPadding * 2
            let contentHeight = proxy.size.height - outerPadding * 2
            let availableWidth = contentWidth - dividerWidth

            let unclampedLeft = availableWidth * splitRatio
            let leftWidth = min(max(minPaneWidth, unclampedLeft), availableWidth - minPaneWidth)
            let rightWidth = availableWidth - leftWidth

            HStack(alignment: .top, spacing: 0) {
                EditableTextPane(title: "Plain text", paneHeight: contentHeight)
                    .frame(width: leftWidth, height: contentHeight, alignment: .topLeading)

                divider(availableWidth: availableWidth, leftWidth: leftWidth)
                    .frame(height: contentHeight)

                MKView(title: "Markdown", paneHeight: contentHeight)
                    .frame(width: rightWidth, height: contentHeight, alignment: .topLeading)
            }
            .padding(outerPadding)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
        .toolbar {
                ToolbarItem {
                    Button("Save") {
                        isExporting = true
                    }
                    .buttonStyle(.glass)
                    .tint(Color.accentColor)
                }
            }
        .fileExporter(
            isPresented: $isExporting,
            document: TextDocument(text: textModel.text),
            contentType: .text,
            defaultFilename: "Untitled.md"
        ) { result in
            switch result {
            case .success(let url):
                print("---> saved to \(url)")
            case .failure(let error):
                print("---> save error: \(error)")
            }
        }
    }

    private func divider(availableWidth: CGFloat, leftWidth: CGFloat) -> some View {
        Rectangle()
            .fill(.clear)
            .frame(width: dividerWidth)
            .overlay {
                Capsule()
                    .fill(.separator)
                    .frame(width: 4)
            }
            .contentShape(Rectangle())
            .gesture(
                DragGesture()
                    .onChanged { value in
                        let proposedLeft = leftWidth + value.translation.width
                        let clampedLeft = min(max(minPaneWidth, proposedLeft), availableWidth - minPaneWidth)
                        splitRatio = clampedLeft / availableWidth
                    }
            )
            #if os(macOS)
            .onHover { hovering in
                if hovering {
                    NSCursor.resizeLeftRight.push()
                } else {
                    NSCursor.pop()
                }
            }
            #endif
    }
}

struct TextDocument: FileDocument {
    static var readableContentTypes: [UTType] { [.plainText, .text] }

    var text: String

    init(text: String) {
        self.text = text
    }

    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents,
              let text = String(data: data, encoding: .utf8) else {
            throw CocoaError(.fileReadCorruptFile)
        }
        self.text = text
    }

    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        FileWrapper(regularFileWithContents: Data(text.utf8))
    }
}
