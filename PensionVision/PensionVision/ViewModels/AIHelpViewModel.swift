//
//  AIHelpViewModel.swift
//  PensionVision
//
//  Created by Krystal D on 17/11/2025.
//

import Foundation
import SwiftUI

@MainActor
class AIHelpViewModel: ObservableObject {
    @Published var question: String = ""
    @Published var aiAnswer: String = ""
    
    struct GeminiPart: Codable {
        let text: String
    }
    
    struct GeminiContent: Codable {
        let parts: [GeminiPart]
    }
    
    struct GeminiCandidate: Codable {
        let content: GeminiContent
    }
    
    struct GeminiResponse: Codable {
        let candidates: [GeminiCandidate]?
    }
    struct GeminiRequest: Codable {
        let contents: [GeminiContent]
    }
    
    func ai() async {
        let q = question
        guard !q.isEmpty else {
            aiAnswer = "Please enter a question."
            return
        }
        aiAnswer = ""
        
        do {
            let urlString = "\(AppConfig.aiEndpoint)?key=\(AppConfig.aiAPIKey)"
            guard let url = URL(string: urlString) else {
                aiAnswer = "Invalid URL."
                return
            }
            let qBody = GeminiRequest(
                contents: [
                    GeminiContent(
                        parts: [GeminiPart(text: q)])]
            )
            let encodedBody = try JSONEncoder().encode(qBody)
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "POST"
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = encodedBody
            
            let (data, _) = try await URLSession.shared.data(for: urlRequest)
            
            let decodedResponse = try JSONDecoder().decode(GeminiResponse.self, from: data)
        
            if let answer = decodedResponse.candidates?.first?.content.parts.first?.text {
                aiAnswer = answer
            } else {
                aiAnswer = "No response."
            }
        } catch {
            aiAnswer = "Something went wrong. Please try again later."
        }
        
    }
    
}
