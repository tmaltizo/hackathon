////
////  VisionProCodeHelperView.swift
////  pro.spec.tive-demo
////
////  Created by 290028062 on 11/14/24.
////
//
//import SwiftUI
//
//struct VisionProCodeHelperView: View {
//@StateObject private var speechRecognizer = SpeechRecognizer()
//@StateObject private var gptRequest = GPTRequest()
//@State private var highlightedCode = """
//for num in range(1,101):
//    string = ""
//    if num % 3 == 0:
//        string = string + "Fizz"
//    if num % 4 == 0:
//        string = string + "Buzz"
//    if num % 4 != 0 and num % 3 != 0:
//        string = string + str(num)
//    print(string)
//"""
//@State private var gptResponse = ""
//    
//var body: some View {
//    VStack {
//        CodeHighlightView()
//        
//        Text(speechRecognizer.recognizedText)
//        
//        if !gptResponse.isEmpty {
//            Text("GPT Explanation:")
//            Text(gptResponse)
//                .padding()
//                .background(Color.gray.opacity(0.2))
//                .cornerRadius(10)
//        }
//    }
//    .onAppear {
//        speechRecognizer.startListening()
//        NotificationCenter.default.addObserver(forName: .codeQueryDetected, object: nil, queue: .main) { _ in
//            gptRequest.sendCodeQuery(speechRecognizer.userPrompt, highlightedCode) { response in
//                gptResponse = response
//            }
//        }
//    }
//}
//}
