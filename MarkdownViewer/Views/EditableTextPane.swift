//
//  EditableTextPane.swift
//  MarkdownViewer
//
//  Created by Ringo Wathelet on 2026/04/26.
//
import SwiftUI
import UniformTypeIdentifiers


struct EditableTextPane: View {
    let title: String
    @Binding var text: String
    let paneHeight: CGFloat
    
    @State private var fileURL: URL = FileManager.default.temporaryDirectory
    @State private var isTargeted = false
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 12) {
                Text(title).font(.headline)
                
                RoundedRectangle(cornerRadius: 8)
                    .fill(isTargeted ? Color.accentColor.opacity(0.2) : Color.green.opacity(0.3))
                    .frame(height: 50)
                    .overlay {
                        Text("Drop file area").foregroundStyle(.secondary)
                    }
                    .dropDestination(for: URL.self) { urls, _ in
                        handleDrop(urls: urls)
                    } isTargeted: { hovering in
                        isTargeted = hovering
                    }
                
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
        .overlay {
            Rectangle().fill(Color.accentColor.opacity(isTargeted ? 0.2 : 0))
        }
    }
    
    private func handleDrop(urls: [URL]) -> Bool {
        guard let url = urls.first else { return false }
        guard url.isFileURL else { return false }
        fileURL = url
        readFileContent()
        return true
    }
    
    private func readFileContent() {
        let didStartAccessing = fileURL.startAccessingSecurityScopedResource()
        defer {
            if didStartAccessing {
                fileURL.stopAccessingSecurityScopedResource()
            }
        }
        do {
            text = try String(contentsOf: fileURL, encoding: .utf8)
        } catch {
            print(error)
        }
    }
    
}



/*
 
 struct EditableTextPane4: View {
     let title: String
     @Binding var text: String
     let paneHeight: CGFloat

     @State private var isDropModeEnabled = false
     @State private var isTargeted = false

     var body: some View {
         VStack(alignment: .leading, spacing: 12) {
             HStack {
                 Text(title).font(.headline)

                 Spacer()

                 Button(isDropModeEnabled ? "Done" : "Drop File") {
                     isDropModeEnabled.toggle()
                 }
                 .buttonStyle(.borderedProminent)
             }

             ZStack {
                 TextEditor(text: $text)
                     .frame(maxWidth: .infinity, maxHeight: .infinity)
                     .scrollContentBackground(.hidden)
                     .padding(8)
                     .background(.background, in: RoundedRectangle(cornerRadius: 8))

                 if isDropModeEnabled {
                     RoundedRectangle(cornerRadius: 8)
                         .fill(isTargeted ? Color.accentColor.opacity(0.20) : Color.black.opacity(0.001))
                         .contentShape(Rectangle())
                         .dropDestination(for: URL.self) { urls, _ in
                             let handled = handleDrop(urls: urls)
                             if handled {
                                 isDropModeEnabled = false
                             }
                             return handled
                         } isTargeted: { hovering in
                             isTargeted = hovering
                         }

                     VStack(spacing: 8) {
                         Image(systemName: "doc.badge.arrow.down")
                             .font(.largeTitle)
                         Text("Drop a text file here")
                             .font(.headline)
                     }
                     .foregroundStyle(.secondary)
                     .allowsHitTesting(false)
                 }
             }
         }
         .padding()
         .frame(maxWidth: .infinity, minHeight: paneHeight, alignment: .topLeading)
         .background(.quaternary, in: RoundedRectangle(cornerRadius: 12))
     }

     private func handleDrop(urls: [URL]) -> Bool {
         guard let fileURL = urls.first, fileURL.isFileURL else { return false }

         let didStartAccessing = fileURL.startAccessingSecurityScopedResource()
         defer {
             if didStartAccessing {
                 fileURL.stopAccessingSecurityScopedResource()
             }
         }

         do {
             text = try String(contentsOf: fileURL, encoding: .utf8)
             return true
         } catch {
             print("read error: \(error)")
             return false
         }
     }
 }




 struct EditableTextPane7: View {
     let title: String
     @Binding var text: String
     let paneHeight: CGFloat
     
     @State private var fileURL: URL = FileManager.default.temporaryDirectory
     @State private var isTargeted = false
     

     var body: some View {
         ZStack {
             VStack(alignment: .leading, spacing: 12) {
                 Text(title).font(.headline)
                 
                 ZStack {
                     TextEditor(text: $text)
                         .frame(maxWidth: .infinity, maxHeight: .infinity)
                         .scrollContentBackground(.hidden)
                         .padding(8)
                         .background(.background, in: RoundedRectangle(cornerRadius: 8))
                     
                     RoundedRectangle(cornerRadius: 8)
                         .fill(isTargeted ? Color.accentColor.opacity(0.20) : Color.white.opacity(0.001))
                         .contentShape(Rectangle())
                         .dropDestination(for: URL.self) { urls, _ in
                             handleDrop(urls: urls)
                         } isTargeted: { hovering in
                             isTargeted = hovering
                         }
                 }
             }
             .padding()
             .frame(maxWidth: .infinity, minHeight: paneHeight, alignment: .topLeading)
             .background(.quaternary, in: RoundedRectangle(cornerRadius: 12))
         }
         .overlay {
             Rectangle().fill(Color.accentColor.opacity(isTargeted ? 0.2 : 0))
         }
     }
     
     private func handleDrop(urls: [URL]) -> Bool {
         guard let url = urls.first else { return false }
         guard url.isFileURL else { return false }
         fileURL = url
         readFileContent()
         return true
     }
     
     private func readFileContent() {
         let didStartAccessing = fileURL.startAccessingSecurityScopedResource()
         defer {
             if didStartAccessing {
                 fileURL.stopAccessingSecurityScopedResource()
             }
         }
         do {
             text = try String(contentsOf: fileURL, encoding: .utf8)
         } catch {
             print(error)
         }
     }
     
 }




 */
