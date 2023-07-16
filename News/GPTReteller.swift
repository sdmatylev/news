//
//  GPTRetailer.swift
//  News
//
//  Created by Савелий on 15.07.2023.
//

import Foundation

func makeChatRequest(_ message: String, completitions: @escaping (String?) -> Void) {
    guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else {
        print("Invalid API endpoint URL")
        return
    }
    
    let parameters: [String: Any] = [
        "model": "gpt-3.5-turbo",
        "messages": [["role": "system",
                     "content": "Ты профессиональный комментатор новостей. прокомментируй новость со следующим заголовком: \(message)"]],
    ]
    
    let headers = [
        "Authorization": "Bearer \(apiKey)",
        "Content-Type": "application/json"
    ]
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.allHTTPHeaderFields = headers
    
    do {
        let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
        request.httpBody = jsonData
    } catch {
        print("Error encoding JSON data: \(error)")
        return
    }
    
    let session = URLSession.shared
    let task = session.dataTask(with: request) { (data, response, error) in
        if let error = error {
            print("Error making API request: \(error)")
            completitions(nil)
            return
        }
        
        guard let data = data else {
            print("No data received")
            completitions(nil)
            return
        }
        do {
            let jsonObject = try JSONDecoder().decode(TranslationResponse.self, from: data)
            completitions(jsonObject.resultText)
        }catch {
            completitions(nil)
        }
    }
    
    task.resume()
}

struct TranslationResponse: Decodable {
    var id: String
    var object: String
    var created: Int
    var choices: [TextCompletionChoice]
    
    var resultText: String {
        choices.map(\.message.content).joined(separator: "\n")
    }
}

extension TranslationResponse {
    struct TextCompletionChoice: Decodable{
        var index: Int
        var message: Messages
        var finish_reason: String
    }
}

struct Messages: Codable {
    let role: String
    let content: String
}
