//
//  OptionsView.swift
//  Trivia Game
//
//  Created by Fiyinfoluwa Afolayan on 3/10/25.
//

import SwiftUI

struct OptionsView: View {
    @State private var numberOfQuestions = 10
    @State private var selectedCategory = "Any Category"
    @State private var selectedDifficulty = "Any"
    @State private var selectedType = "multiple" // "multiple" for Multiple Choice, "boolean" for True/False
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Trivia Options")) {
                    Stepper("Number of Questions: \(numberOfQuestions)", value: $numberOfQuestions, in: 1...50)
                    
                    Picker("Category", selection: $selectedCategory) {
                        Text("Any Category").tag("Any Category")
                        Text("General Knowledge").tag("9")
                        Text("Science & Nature").tag("17")
                        // Add additional categories as needed.
                    }
                    
                    Picker("Difficulty", selection: $selectedDifficulty) {
                        Text("Any").tag("Any")
                        Text("Easy").tag("easy")
                        Text("Medium").tag("medium")
                        Text("Hard").tag("hard")
                    }
                    
                    Picker("Type", selection: $selectedType) {
                        Text("Multiple Choice").tag("multiple")
                        Text("True/False").tag("boolean")
                    }
                }
                
                // Navigation link to start the trivia game, passing selected options.
                NavigationLink(destination: TriviaGameView(
                    numberOfQuestions: numberOfQuestions,
                    category: selectedCategory == "Any Category" ? nil : selectedCategory,
                    difficulty: selectedDifficulty == "Any" ? nil : selectedDifficulty,
                    type: selectedType)) {
                    Text("Start Trivia Game")
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .navigationTitle("Trivia Options")
        }
    }
}

struct OptionsView_Previews: PreviewProvider {
    static var previews: some View {
        OptionsView()
    }
}
