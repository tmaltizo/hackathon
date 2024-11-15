import SwiftUI
import RealityKit
import RealityKitContent

extension Notification.Name{
    static let codeQueryDetected = Notification.Name("codeQueryDetected")
    static let highlightedLinePosition = Notification.Name("highlightedLinePosition")
}

struct CodeEditorView: View {
    @StateObject private var speechRecognizer = SpeechRecognizer()
    @StateObject private var gptRequest = GPTRequest()
    @State private var gptResponse: String?
    @State private var showPopup = false
    @State private var popupPosition = CGPoint(x: 500, y: 500)
    @State private var codeLines: [String] = []
    @State private var highlightedLines: Set<Int> = []
    @State private var highlightedLinePosition: CGFloat = 0
    @State private var selectedFile: FileItem? = fileTreeData[0].children?[0].children?[1] // main.py
    @State private var text: String = ""
    
    var body: some View {
        NavigationView {
            FileTreeView(items: fileTreeData, selectedFile: $selectedFile)
                .frame(minWidth: 200)
                .padding(.top, 40)
                .padding(.leading, 40)
            ZStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(codeLines.indices, id: \.self) { index in
                            CodeLineView(
                                lineNumber: index + 1,
                                text: $codeLines[index],
                                codeLines: $codeLines,
                                isHighlighted: highlightedLines.contains(index),
                                keywords: pythonKeywords
                            )
                            .background(highlightedLines.contains(index) ? Color.yellow.opacity(0.3) : Color.clear)
                            .gesture(
                                TapGesture(count: 1).onEnded {
                                    highlightLine(at: index)
                                }
                            )
                        }
                    }
                    .padding(.top, 40)
                    .padding(.leading, 40)
                }
                if showPopup, let response = gptResponse {
                    GPTPopupView(response: response, position: $popupPosition, isVisible: $showPopup)
                }
            }
            .navigationTitle(selectedFile?.name ?? "Select a file")
            .onAppear {
                speechRecognizer.startListening()
                NotificationCenter.default.addObserver(forName: .codeQueryDetected, object: nil, queue: .main) { _ in
                    handleCodeQuery()
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: .highlightedLinePosition)) { notification in
                if let userInfo = notification.userInfo, let position = userInfo["position"] as? CGFloat {
                    highlightedLinePosition = position
                    // Update popup position
                    popupPosition = CGPoint(x: 400, y: highlightedLinePosition)
                }
            }
        }
        .onAppear {
            if let selectedFile = selectedFile, let content = fileContents[selectedFile.name]{
                text = content
                codeLines = text.components(separatedBy: CharacterSet.newlines)
            }
        }
        .onChange(of : selectedFile){newValue in
            if let newFile = newValue, let content = fileContents[newFile.name]{
                text = content
                codeLines = text.components(separatedBy: CharacterSet.newlines)
            }
            else{
                text = " No content available for this file"
            }
        }
    }
    
    private func highlightLine(at index: Int) {
        if highlightedLines.contains(index) {
            highlightedLines.remove(index)
        } else {
            highlightedLines.insert(index)
        }
    }
    
    private func handleCodeQuery() {
        let selectedCode = highlightedLines.sorted().map { codeLines[$0] }.joined(separator: "\n")
        print(selectedCode)
        gptRequest.sendCodeQuery(speechRecognizer.userPrompt, selectedCode) { response in
            self.gptResponse = response
            self.showPopup = true
        }
    }
}


struct CodeLineView: View {
    let lineNumber: Int
    @Binding var text: String
    @Binding var codeLines: [String]
    let isHighlighted: Bool
    let keywords: [String]
    
    var body: some View {
        HStack(alignment: .top) {
            Text("\(lineNumber)")
                .foregroundColor(.gray)
                .frame(width: 30, alignment: .trailing)
            SyntaxHighlightingTextField(text: $text, keywords: keywords)
            .font(.system(.body, design: .monospaced))
            .padding(.leading, 5)
            .textFieldStyle(DefaultTextFieldStyle())
            Spacer()
        }
        .padding(.vertical, 2)
        .background(
            GeometryReader { geometry in
                Color.clear.onAppear {
                    // Notify the parent view about the position
                    if isHighlighted {
                        NotificationCenter.default.post(
                            name: .highlightedLinePosition,
                            object: nil,
                            userInfo: ["position": geometry.frame(in: .global).midY]
                        )
                    }
                }
            }
        )
        .background(isHighlighted ? Color.yellow.opacity(0.3) : Color.clear)
    }
}





let fileContents: [String: String] = [
    "main.py": """
def main():
    print("Hello, World!")

if __name__ == "__main__":
    main()
""",
    "utils.py": """
def add(a, b):
    return a + b

def subtract(a, b):
    return a - b
""",
    "module.py": """
def module_function():
    print("Module function called.")
""",
    "helper.py": """
def helper_function():
    print("Helper function.")
""",
    "__init__.py": """
# This file makes this directory a package.
""",
    "test_main.py": """
import unittest
from src.main import main

class TestMain(unittest.TestCase):
    def test_main(self):
        self.assertIsNone(main())

if __name__ == '__main__':
    unittest.main()
""",
    "test_utils.py": """
import unittest
from src.utils import add

class TestUtils(unittest.TestCase):
    def test_add(self):
        self.assertEqual(add(2, 3), 5)

if __name__ == '__main__':
    unittest.main()
""",
    "index.md": """
# Documentation Index

Welcome to the project documentation.
""",
    "usage.md": """
# Usage Guide

Instructions on how to use the project.
""",
    "README.md": """
# MyPythonProject

A sample Python project demonstrating structure and syntax highlighting.
""",
    "LICENSE": """
MIT License
""",
    "requirements.txt": """
numpy
pandas
requests
""",
    "setup.py": """
from setuptools import setup, find_packages

setup(
    name='MyPythonProject',
    version='0.1',
    packages=find_packages(),
    install_requires=[
        'numpy',
        'pandas',
        'requests',
    ],
)
""",
    ".gitignore": """
# Byte-compiled / optimized / DLL files
__pycache__/
*.py[cod]
*$py.class

# Environments
.env
.venv
""",
]

// Define Python keywords
let pythonKeywords = [
    "def", "class", "import", "as", "if", "else", "elif", "return", "for", "while",
    "break", "continue", "pass", "from", "with", "lambda", "try", "except", "finally",
    "raise", "in", "not", "or", "and", "is", "global", "nonlocal", "assert", "yield"
]
