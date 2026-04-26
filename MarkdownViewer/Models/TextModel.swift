//
//  TextModel.swift
//  MarkdownViewer
//
//  Created by Ringo Wathelet on 2026/04/26.
//
import SwiftUI


@Observable
final class TextModel {

    var text: String = """
                This is a *lighthearted* but **perfectly serious** paragraph where `inline code` lives \
                happily alongside ~~a terrible idea~~ a better one, a [useful link](https://example.com), \
                and a bit of _extra emphasis_ just for style. To keep things interesting without overdoing \
                it, here’s a completely random image that adapts to the container width:

                ![Random image](https://picsum.photos/seed/textual/400/250)
                """
    
}
