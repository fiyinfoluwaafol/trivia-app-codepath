//
//  TriviaAPI.swift
//  Trivia Game
//
//  Created by Fiyinfoluwa Afolayan on 3/10/25.
//

import Foundation

class TriviaAPI {
    static let shared = TriviaAPI()
    
    func fetchTrivia(numberOfQuestions: Int, category: String?, difficulty: String?, type: String?, completion: @escaping ([TriviaQuestion]) -> Void) {
        var urlString = "https://opentdb.com/api.php?amount=\(numberOfQuestions)"
        if let category = category, category != "Any Category" {
            urlString += "&category=\(category)"
        }
        if let difficulty = difficulty, difficulty != "Any" {
            urlString += "&difficulty=\(difficulty)"
        }
        if let type = type {
            urlString += "&type=\(type)"
        }
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL: \(urlString)")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching trivia: \(error)")
                return
            }
            guard let data = data else {
                print("No data returned")
                return
            }
            
            do {
                let triviaResponse = try JSONDecoder().decode(TriviaResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(triviaResponse.results)
                }
            } catch {
                print("Decoding error: \(error)")
            }
        }.resume()
    }
}
