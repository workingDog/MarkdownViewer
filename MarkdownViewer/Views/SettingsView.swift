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

    private var roundSize: Binding<Double> {
        Binding(
            get: { fontSize },
            set: { fontSize = $0.rounded() }
        )
    }
    
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
                    Text("\(Int(fontSize.rounded()))")
                    Slider(value: roundSize, in: 10...40).padding(20)
                    Spacer()
                }
            }
        }
    }
}
