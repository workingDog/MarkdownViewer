//
//  HtmlView.swift
//  MarkdownViewer
//
//  Created by Ringo Wathelet on 2026/05/14.
//
import SwiftUI
import WebKit

struct HtmlView: View {
    let title: String
    @Binding var text: String

    @State private var displayedText = ""
    @State private var page = WebPage()

    var body: some View {
        WebView(page)
            .onAppear {
                displayedText = text
                page.load(html: displayedText)
            }
    }
}
