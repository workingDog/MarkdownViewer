//
//  ContentView.swift
//  MarkdownViewer
//
//  Created by Ringo Wathelet on 2026/04/26.
//
import SwiftUI
#if os(macOS)
import AppKit
#endif


struct ContentView: View {
    @State private var model = TextModel()
    @State private var splitRatio: CGFloat = 0.5

    private let minPaneWidth: CGFloat = 160
    private let dividerWidth: CGFloat = 12
    private let outerPadding: CGFloat = 24

    var body: some View {
        @Bindable var model = model

        GeometryReader { proxy in
            let contentWidth = proxy.size.width - outerPadding * 2
            let contentHeight = proxy.size.height - outerPadding * 2
            let availableWidth = contentWidth - dividerWidth

            let unclampedLeft = availableWidth * splitRatio
            let leftWidth = min(max(minPaneWidth, unclampedLeft), availableWidth - minPaneWidth)
            let rightWidth = availableWidth - leftWidth

            HStack(alignment: .top, spacing: 0) {
                EditableTextPane(title: "Plain text", text: $model.text, paneHeight: contentHeight)
                    .frame(width: leftWidth, height: contentHeight, alignment: .topLeading)

                divider(availableWidth: availableWidth, leftWidth: leftWidth)
                    .frame(height: contentHeight)

                MKView(title: "Markdown", text: $model.text, paneHeight: contentHeight)
                    .frame(width: rightWidth, height: contentHeight, alignment: .topLeading)
            }
            .padding(outerPadding)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
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
