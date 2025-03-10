//
//  TriviaGameViewModel.swift
//  Trivia Game
//
//  Created by Fiyinfoluwa Afolayan on 3/10/25.
//

import Foundation
import Combine

class TriviaGameViewModel: ObservableObject {
    @Published var questions: [TriviaQuestion] = []
    @Published var userAnswers: [UUID: String] = [:] // Map each question to the selected answer
    @Published var score = 0
    @Published var showScoreAlert = false
    @Published var submitted = false
    @Published var remainingTime: Int = 30  // Timer set to 30 seconds for each game
    
    private var timerSubscription: AnyCancellable?
    
    // Fetch trivia questions from the API
    func fetchQuestions(numberOfQuestions: Int, category: String?, difficulty: String?, type: String?) {
        TriviaAPI.shared.fetchTrivia(numberOfQuestions: numberOfQuestions, category: category, difficulty: difficulty, type: type) { [weak self] questions in
            self?.questions = questions
            self?.startTimer()  // Start timer once questions are loaded
        }
    }
    
    // Calculate score and mark the quiz as submitted
    func calculateScore() {
        var count = 0
        for question in questions {
            if let userAnswer = userAnswers[question.id],
               userAnswer == question.correct_answer {
                count += 1
            }
        }
        score = count
        submitted = true
        showScoreAlert = true
        stopTimer()
    }
    
    // Timer management
    func startTimer() {
        remainingTime = 30  // Reset timer for a new game
        
        timerSubscription = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                if self.remainingTime > 0 {
                    self.remainingTime -= 1
                } else {
                    // Auto-submit answers when time runs out
                    if !self.submitted {
                        self.calculateScore()
                    }
                }
            }
    }
    
    func stopTimer() {
        timerSubscription?.cancel()
    }
}
