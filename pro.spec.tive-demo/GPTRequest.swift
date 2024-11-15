//
//  GPTRequest.swift
//  pro.spec.tive-demo
//
//  Created by 290028062 on 11/14/24.
//
import Foundation

class GPTRequest: ObservableObject {
    private let apiKey = "YOUR_API_KEY_HERE" // Replace with your actual API key
    
    func sendCodeQuery(_ userPrompt: String, _ code: String, completion: @escaping (String) -> Void) {
        var prompt = ""
        if userPrompt.count > 10 {
            prompt = "\(userPrompt):\n\n\(code)"
        } else {
            prompt = "Explain this code:\n\n\(code)"
        }
        let url = URL(string: "https://api.openai.com/v1/chat/completions")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters: [String: Any] = [
            "model": "gpt-4o-mini",
            "messages": [
                ["role": "system", "content": "You are a helpful assistant that answers questions user has about code. Any request that doesn't have anything to do with code, respond with \"Get back to work, dude.\""],
                ["role": "user", "content": prompt],
            ],
            "temperature": 0.5,
            "max_tokens": 150
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let data = data, let response = try? JSONDecoder().decode(GPTResponse.self, from: data) {
                DispatchQueue.main.async {
                    completion(response.choices.first?.message.content ?? "No response")
                }
            } else {
                print("Error fetching GPT response: \(error?.localizedDescription ?? "Unknown error")")
            }
        }.resume()
    }
}

struct GPTResponse: Decodable {
    let choices: [Choice]
    struct Choice: Decodable {
        let message: Message
        struct Message: Decodable {
            let content: String
        }
    }
}
