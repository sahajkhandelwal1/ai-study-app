//
//  ContentView.swift
//  AI Study App
//
//  Created by Sahaj on 10/20/24.
//

import SwiftUI


enum AnswerType: Equatable {
    case boolean(Bool)
    case string(String)
    var stringValue: String {
        switch self {
        case .boolean(let value):
            return value ? "True" : "False"
        case .string(let value):
            return value
        }
    }
}

enum QuestionType {
    case trueFalse
    case multipleChoice
    case shortAnswer
    case fillInTheBlank
}

struct Question: Identifiable {
    let id = UUID()
    let text: String
    let type: QuestionType
    let correctAnswer: AnswerType
    var choices: [String]?
    var userAnswer: AnswerType?
    var isCorrect: Bool?
    
   
}


class QuizSession: ObservableObject {
    @Published var questions: [Question]
    @Published var currentQuestionIndex: Int
    let topic: String
    
    init(topic: String, questions: [Question]) {
        self.topic = topic
        self.questions = questions
        self.currentQuestionIndex = 0
    }
    
    var isComplete: Bool {
        questions.allSatisfy {
            $0.isCorrect != nil
        }
    }
    
    var score: String {
        let correct = questions.filter {
            $0.isCorrect == true
        }.count
        
        let total = questions.count
        return "\(correct)/\(total)"
    }
    
    func checkAnswer(_ answer: AnswerType, index: Int) {
        var question = questions[index]
        question.userAnswer = answer
        question.isCorrect = answer == question.correctAnswer
        questions[index] = question
    }
    
}

struct QuestionGenerator {
    static func generateQuestions(topic: String, count: Int, type: QuestionType) -> [Question] {
        var questions: [Question] = []
        
        for i in 0..<count {
            switch type {
            case .trueFalse:
                questions.append(Question(
                    text: "Sample True/False Question \(i + 1)",
                    type: .trueFalse,
                    correctAnswer: .boolean(true)
                ))
            case .multipleChoice:
                questions.append(Question(
                    text: "Sample MCQ \(i + 1)",
                    type: .multipleChoice,
                    correctAnswer: .string("A"),
                    choices: ["A", "B", "C", "D"]
                ))
            case .fillInTheBlank:
                questions.append(Question(
                    text: "Sample Fill in Blank \(i + 1) _____",
                    type: .fillInTheBlank,
                    correctAnswer: .string("answer")
                ))
            case .shortAnswer:
                questions.append(Question(
                    text: "Sample Short Answer \(i + 1)?",
                    type: .shortAnswer,
                    correctAnswer: .string("answer")
                ))
            }
        }
        return questions
    }
}


struct QuestionProgressView: View {
    @ObservedObject var session: QuizSession
    
    
    
    var body: some View {
        HStack {
            ForEach(session.questions.indices, id: \.self) { index in
                Rectangle()
                    .fill(colorForAnswer(session.questions[index].isCorrect))
                    .frame(height: 40)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(maxHeight: .infinity, alignment: .top)
        .padding(.horizontal)
    }
    
    private func colorForAnswer(_ answer: Bool?) -> Color {
        if answer == true {
            return .green
        } else if answer == false {
            return .red
        } else {
            return .gray
        }
    }
}

struct TrueFalseQuestionView: View {
    @ObservedObject var session: QuizSession
    @Binding var questionIndex: Int
    @State private var selectedAnswer: Bool?
    @State private var hasChecked: Bool = false
    
    var body: some View {
        VStack {
            Text(session.questions[questionIndex].text)
                .font(.title2)
                .padding()
            
            
            Menu {
                Button("True") { selectedAnswer = true }
                Button("False") { selectedAnswer = false }
            } label: {
                Label(
                    title: { Text(selectedAnswer == nil ? "Select Answer": "\(selectedAnswer! ? "True" : "False")")},
                    icon: { Image(systemName: "arrowtriangle.down.fill")}
                )
                .font(.title3)
            }
            .padding()
            
            Button("Check Answer") {
                guard let selected = selectedAnswer else { return }
                session.checkAnswer(.boolean(selected), index: questionIndex)
                hasChecked = true
            }
            .disabled(selectedAnswer == nil || hasChecked)
            
            if hasChecked {
                
                if session.questions[questionIndex].isCorrect == true {
                    Text("Correct!")
                        .foregroundColor(.green)
                        .bold()
                } else {
                    Text("Incorrect")
                        .foregroundColor(.red)
                        .bold()
                }
                
                NavigationLink("Next Question") {
                    QuestionContainerView(session: session, questionIndex: .constant(questionIndex + 1))
                }
                .buttonStyle(.bordered)
                .padding()
            }
            Spacer()
        }
    }
    
}

struct FillInTheBlankQuestionView: View {
    @ObservedObject var session: QuizSession
    @Binding var questionIndex: Int
    @State private var answer: String = ""
    @State private var hasChecked: Bool = false
    
    var body: some View {
        VStack {
            Text(session.questions[questionIndex].text)
                .font(.title2)
                .padding()
            
            
            TextField("Your Answer", text: $answer)
                .textFieldStyle(.roundedBorder)
                .padding()
            
            Button("Check Answer") {
                session.checkAnswer(.string(answer.lowercased()), index: questionIndex)
                hasChecked = true
            }
            .disabled(answer.isEmpty || hasChecked)
            
            if hasChecked {
                
                if session.questions[questionIndex].isCorrect == true {
                    Text("Correct!")
                        .foregroundColor(.green)
                        .bold()
                } else {
                    Text("Incorrect")
                        .foregroundColor(.red)
                        .bold()
                }
                
                NavigationLink("Next Question") {
                    QuestionContainerView(session: session, questionIndex: .constant(questionIndex + 1))
                }
                .buttonStyle(.bordered)
                .padding()
            }
        }
    }
}

struct ShortAnswerQuestionView: View {
    @ObservedObject var session: QuizSession
    @Binding var questionIndex: Int
    @State private var answer: String = ""
    @State private var hasChecked: Bool = false
    
    var body: some View {
        VStack {
            Text(session.questions[questionIndex].text)
                .font(.title2)
                .padding()
            
            
            TextField("Your Answer", text: $answer)
                .textFieldStyle(.roundedBorder)
                .padding()
            
            Button("Check Answer") {
                session.checkAnswer(.string(answer.lowercased()), index: questionIndex)
                hasChecked = true
            }
            .disabled(answer.isEmpty || hasChecked)
            
            if hasChecked {
                
                if session.questions[questionIndex].isCorrect == true {
                    Text("Correct!")
                        .foregroundColor(.green)
                        .bold()
                } else {
                    Text("Incorrect")
                        .foregroundColor(.red)
                        .bold()
                }
                
                NavigationLink("Next Question") {
                    QuestionContainerView(session: session, questionIndex: .constant(questionIndex + 1))
                }
                .buttonStyle(.bordered)
                .padding()
            }
        }
    }
}

struct MultipleChoiceQuestionView: View {
    @ObservedObject var session: QuizSession
    @Binding var questionIndex: Int
    @State private var selectedAnswer: String?
    @State private var hasChecked: Bool = false
    
    var body: some View {
        VStack {
            Text(session.questions[questionIndex].text)
                .font(.title2)
                .padding()
            
            
//            Menu {
//                Button(action: {
//                    selectedAnswer = session.choices[0]
//                }, label: {
//                    Text(session.choices[0])
//                })
//                .buttonStyle(.bordered)
//                Button("False") { selectedAnswer = false }
//                Button("True") { selectedAnswer = true }
//                Button("False") { selectedAnswer = false }
//            } label: {
//                Label(
//                    title: { Text(selectedAnswer == nil ? "Select Answer": "\(selectedAnswer! ? "True" : "False")")},
//                    icon: { Image(systemName: "arrowtriangle.down.fill")}
//                )
//                .font(.title3)
//            }
//            .padding()
            
            if let choices = session.questions[questionIndex].choices {
                ForEach(choices, id: \.self) { choice in
                    Button(action: {
                        selectedAnswer = choice
                    }) {
                        HStack {
                            Text(choice)
                                .foregroundColor(.primary)
                            Spacer()
                            if selectedAnswer == choice {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.blue)
                            } else {
                                Image(systemName: "circle")
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding()
                    }
                    .padding(.horizontal)
                }
            }
            
            Button("Check Answer") {
                if let selected = selectedAnswer {
                    session.checkAnswer(.string(selected), index: questionIndex)
                    hasChecked = true
                }
            }
            .disabled(selectedAnswer == nil || hasChecked)
            
            if hasChecked {
                
                if session.questions[questionIndex].isCorrect == true {
                    Text("Correct!")
                        .foregroundColor(.green)
                        .bold()
                } else {
                    Text("Incorrect")
                        .foregroundColor(.red)
                        .bold()
                }
                
                NavigationLink("Next Question") {
                    QuestionContainerView(session: session, questionIndex: .constant(questionIndex + 1))
                }
                .buttonStyle(.bordered)
                .padding()
            }
        }
    }
}

struct QuestionContainerView: View {
    @ObservedObject var session: QuizSession
    @Binding var questionIndex: Int
    
    var body: some View {
        VStack {
            QuestionProgressView(session: session)
            
            if questionIndex >= session.questions.count {
                ResultsView(session: session)
            } else {
                switch session.questions[questionIndex].type {
                case .trueFalse:
                    TrueFalseQuestionView(session: session, questionIndex: $questionIndex)
                case .fillInTheBlank:
                    FillInTheBlankQuestionView(session: session, questionIndex: $questionIndex)
                case .multipleChoice:
                    MultipleChoiceQuestionView(session: session, questionIndex: $questionIndex)
                case .shortAnswer:
                    ShortAnswerQuestionView(session: session, questionIndex: $questionIndex)
                }
            }
            
        }
    }
}



struct ResultsView: View {
    @ObservedObject var session: QuizSession
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            Text("Quiz Completed!")
                .font(.title)
                .padding()
            
            
            Text("Score: \(session.score)")
                .font(.title2)
                .padding()
            
            Button(action: {
                dismiss()
            }) {
                Text("Reset")
            }
            
//            QuestionProgressView(session: session)
        }
        
    }
}


struct QuizSetupView: View {
    @State private var topic: String = ""
    @State private var questionCount: Int = 5
    @State private var selectedType: QuestionType = .trueFalse
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                TextField("Study Topic", text: $topic)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                
                Stepper("Number of Questions: \(questionCount)", value: $questionCount, in: 1...20)
                    .padding()
                
                Picker("Question Type", selection: $selectedType) {
                    Text("True/False").tag(QuestionType.trueFalse)
                    Text("Fill In The Blank").tag(QuestionType.fillInTheBlank)
                    Text("Short Answer").tag(QuestionType.shortAnswer)
                    Text("Multiple Choice").tag(QuestionType.multipleChoice)
                }
                .pickerStyle(.menu)
                
                NavigationLink(
                    destination: QuestionContainerView(
                        session: QuizSession(
                            topic: topic,
                            questions: QuestionGenerator.generateQuestions(
                                topic: topic,
                                count: questionCount,
                                type: selectedType
                            )
                        ),
                        questionIndex: .constant(0)
                    )
                ) {
                    Text("Start Quiz")
                        .font(.title2)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(topic.isEmpty)
            }
            .navigationTitle("Quiz Setup")
        }
    }
}




struct ContentView: View {
    var body: some View {
        QuizSetupView()
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
