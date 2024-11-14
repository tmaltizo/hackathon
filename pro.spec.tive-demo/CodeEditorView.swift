//
//  CodeEditorView.swift
//  pro.spec.tive-demo
//
//  Created by 290028062 on 11/14/24.
//

import SwiftUI

struct CodeEditorView: View {
    @State private var codeText: String = """
def fizzbuzz():
    for num in range(1,101):
        string = ""
        if num % 3 == 0:
            string = string + "Fizz"
        if num % 4 == 0:
            string = string + "Buzz"
        if num % 4 != 0 and num % 3 != 0:
            string = string + str(num)
        print(string)
if __name__ == "__main__":
    fizzbuzz()
"""

    var body: some View {
        VStack {
            Text("Code Editor")
                .font(.title)
                .padding()
            
            TextEditor(text: $codeText)
                .font(.system(.body, design: .monospaced))
                .foregroundColor(.white)
                .background(Color.black)
                .cornerRadius(8)
                .padding()
            
            Spacer()
            
            Button(action: runCode) {
                Text("Run Code")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding()
        .frame(width: 1000, height: 700)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(12)
        .shadow(radius: 10)
    }

    func runCode() {
        print("Code executed: \(codeText)")
    }
}
