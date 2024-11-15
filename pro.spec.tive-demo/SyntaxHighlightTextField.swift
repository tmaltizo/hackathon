import SwiftUI
import UIKit

struct SyntaxHighlightingTextField: UIViewRepresentable {
    @Binding var text: String
    let keywords: [String]
    var font: UIFont = UIFont.monospacedSystemFont(ofSize: 18, weight: .regular)
    var textColor: UIColor = .label
    
    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.delegate = context.coordinator
        textField.font = font
        textField.textColor = textColor
        textField.borderStyle = .none
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.addTarget(context.coordinator, action: #selector(Coordinator.textFieldDidChange(_:)), for: .editingChanged)
        return textField
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        if uiView.text != text {
            uiView.text = text
        }
        applySyntaxHighlighting(to: uiView)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func applySyntaxHighlighting(to textField: UITextField) {
        let attributedText = NSMutableAttributedString(string: text)
        
        // Default attributes
        let fullRange = NSRange(location: 0, length: attributedText.length)
        attributedText.addAttribute(.font, value: font, range: fullRange)
        attributedText.addAttribute(.foregroundColor, value: textColor, range: fullRange)
        
        // Syntax highlighting for keywords
        for keyword in keywords {
            let ranges = rangesOfSubstring(keyword, in: text)
            for range in ranges {
                attributedText.addAttribute(.foregroundColor, value: UIColor.systemPink, range: range)
            }
        }
        
        textField.attributedText = attributedText
    }
    
    func rangesOfSubstring(_ substring: String, in string: String) -> [NSRange] {
        var ranges: [NSRange] = []
        let pattern = "\\b\(NSRegularExpression.escapedPattern(for: substring))\\b"
        if let regex = try? NSRegularExpression(pattern: pattern) {
            let matches = regex.matches(in: string, range: NSRange(string.startIndex..., in: string))
            ranges = matches.map { $0.range }
        }
        return ranges
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: SyntaxHighlightingTextField
        
        init(_ parent: SyntaxHighlightingTextField) {
            self.parent = parent
        }
        
        @objc func textFieldDidChange(_ textField: UITextField) {
            parent.text = textField.text ?? ""
            parent.applySyntaxHighlighting(to: textField)
        }
    }
}
