//
//  AdvancedTextView.swift
//  pro.spec.tive-demo
//
//  Created by 290028062 on 11/14/24.
//

import SwiftUI
import UIKit

struct AdvancedTextView: UIViewRepresentable {
@Binding var text: String

func makeUIView(context: Context) -> UITextView {
    let textView = UITextView()
    textView.isEditable = true
    textView.isSelectable = true
    textView.backgroundColor = UIColor.black
    textView.textColor = UIColor.white
    textView.font = UIFont.monospacedSystemFont(ofSize: 16, weight: .regular)
    return textView
}

func updateUIView(_ uiView: UITextView, context: Context) {
    uiView.text = text
}
}
