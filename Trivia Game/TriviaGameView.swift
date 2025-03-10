//
//  TriviaGameView.swift
//  Trivia Game
//
//  Created by Fiyinfoluwa Afolayan on 3/10/25.
//

import SwiftUI

struct TriviaGameView: View {
    let numberOfQuestions: Int
    let category: String?
    let difficulty: String?
    let type: String?
    
    @StateObject private var viewModel = TriviaGameViewModel()
    
    var body: some View {
        VStack {
            // Display the countdown timer
            Text("Time Remaining: \(viewModel.remainingTime)s")
                .font(.headline)
                .padding()
            
            if viewModel.questions.isEmpty {
                // Show a loading indicator while questions are being fetched
                ProgressView("Loading Questions...")
                    .onAppear {
                        viewModel.fetchQuestions(numberOfQuestions: numberOfQuestions, category: category, difficulty: difficulty, type: type)
                    }
            } else {
                List {
                    ForEach(viewModel.questions) { question in
                        VStack(alignment: .leading, spacing: 10) {
                            Text(question.question)
                                .font(.headline)
                            
                            ForEach(shuffledAnswers(for: question), id: \.self) { answer in
                                HStack {
                                    Text(answer)
                                    Spacer()
                                    // Show a checkmark if this is the selected answer
                                    if viewModel.userAnswers[question.id] == answer {
                                        Image(systemName: "checkmark.circle.fill")
                                    }
                                }
                                .padding(.vertical, 4)
                                .contentShape(Rectangle())
                                .background(answerBackground(for: question, answer: answer))
                                .onTapGesture {
                                    // Allow selection only before submission
                                    if !viewModel.submitted {
                                        viewModel.userAnswers[question.id] = answer
                                    }
                                }
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
                .listStyle(PlainListStyle())
                
                // Submission button (disabled after submission)
                Button(viewModel.submitted ? "Game Over" : "Submit Answers") {
                    if !viewModel.submitted {
                        viewModel.calculateScore()
                    }
                }
                .padding()
                .buttonStyle(.borderedProminent)
                .disabled(viewModel.submitted)
                .alert("Your Score", isPresented: $viewModel.showScoreAlert) {
                    Button("OK", role: .cancel) {}
                } message: {
                    Text("You scored \(viewModel.score) out of \(viewModel.questions.count)!")
                }
            }
        }
        .navigationTitle("Trivia Game")
    }
    
    // Shuffle the answer options for a given question.
    func shuffledAnswers(for question: TriviaQuestion) -> [String] {
        var answers = question.incorrect_answers
        answers.append(question.correct_answer)
        return answers.shuffled()
    }
    
    // Provide background colors after submission:
    // Green for correct answers and red for incorrect selections.
    @ViewBuilder
    func answerBackground(for question: TriviaQuestion, answer: String) -> some View {
        if viewModel.submitted {
            if answer == question.correct_answer {
                Color.green.opacity(0.3)
            } else if let selected = viewModel.userAnswers[question.id], selected == answer {
                Color.red.opacity(0.3)
            } else {
                Color.clear
            }
        } else {
            Color.clear
        }
    }
}

struct TriviaGameView_Previews: PreviewProvider {
    static var previews: some View {
        TriviaGameView(numberOfQuestions: 10, category: nil, difficulty: nil, type: "multiple")
    }
}
