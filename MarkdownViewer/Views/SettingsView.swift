//
//  SettingsView.swift
//  MarkdownViewer
//
//  Created by Ringo Wathelet on 2026/04/27.
//
import Foundation
import SwiftUI


struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("fontSize") private var fontSize = 20.0
    
    @State private var sliderFontSize = 20.0

    var body: some View {
        ZStack {
            AppTheme.backGradient.ignoresSafeArea()

            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Button("Done") {
                        dismiss()
                    }
                    .buttonStyle(.bordered)
                    .padding(5)

                    Spacer()
                }
                .padding(5)

                VStack {
                    Text("Editor Font Size").padding(10)

                    Text("\(Int(sliderFontSize.rounded()))")

                    Slider(value: $sliderFontSize, in: 10...40)
                        .padding(20)
                        .onChange(of: sliderFontSize) {
                            fontSize = sliderFontSize.rounded()
                        }

                    Spacer()
                }
            }
        }
        .onAppear {
            sliderFontSize = fontSize
        }
    }
}

