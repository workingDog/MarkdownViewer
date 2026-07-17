//
//  Utility.swift
//  MarkdownViewer
//
//  Created by Ringo Wathelet on 2026/07/17.
//
import Foundation
import SwiftUI
import UniformTypeIdentifiers


struct Utility {
    
    static func readFileContent(fileURL: URL) -> String {
        let didStartAccessing = fileURL.startAccessingSecurityScopedResource()
        defer {
            if didStartAccessing {
                fileURL.stopAccessingSecurityScopedResource()
            }
        }
        do {
            return try String(contentsOf: fileURL, encoding: .utf8)
        } catch {
            print(error)
        }
        return ""
    }
    
    static func writeFileContent(text: String, fileURL: URL) {
        let didStartAccessing = fileURL.startAccessingSecurityScopedResource()
        defer {
            if didStartAccessing {
                fileURL.stopAccessingSecurityScopedResource()
            }
        }
        do {
            try text.write(to: fileURL, atomically: true, encoding: .utf8)
        } catch {
            print(error)
        }
    }
    
}
