//
//  ContentView.swift
//  AI Study App
//
//  Created by Sahaj on 10/20/24.
//

import SwiftUI
import Foundation

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
    
    var apiString: String {
        switch self {
        case .trueFalse:
            return "True/False"
        case .fillInTheBlank:
            return "Fill in the blank"
        case .multipleChoice:
            return "Multiple Choice"
        case .shortAnswer:
            return "Short Answer"
        }
    }
    
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

struct OpenAIResponse: Codable {
    
    struct Choice: Codable {
        
        struct Message: Codable {
            let content: String
        }
        
        
        let message: Message
        let finishReason: String
        
        enum CodingKeys: String, CodingKey {
            case message
            case finishReason = "finish_reason"
        }
    }

    
    let id: String
    let object: String
    let created: Int
    let model: String
    let choices: [Choice]
}




//struct Usage: Codable {
//    let promptTokens: Int
//    let completionTokens: Int
//    let totalTokens: Int
//    
//    enum CodingKeys: String, CodingKey {
//        case promptTokens = "prompt_tokens"
//        case completionTokens = "completion_tokens"
//        case totalTokens = "total_tokens"
//    }
//}

struct TFQuestion: Codable {
    let text: String
    let correctAnswer: Bool
}

struct MCQuestion: Codable {
    let text: String
    let correctAnswer: String
    let choices: [String]
}

struct TextQuestion: Codable {
    let text: String
    let correctAnswer: String
}

class OpenAIService {
    
    private var apiKey: String {
        guard let apiKey = ProcessInfo.processInfo.environment["OPENAI_API_KEY"], !apiKey.isEmpty else {
            print("error: OpenAI Api key not found")
            return ""
        }
        return apiKey
    }
    
    static let shared = OpenAIService()
    private init() {}
    
    
    
    func generateQuiz(topic: String, count: Int, type: QuestionType) async throws -> [Question] {
        
        let url = URL(string: "https://api.openai.com/v1/chat/completions")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        
//        let promptTemplate: String
//            
//        switch type {
//        case .trueFalse:
//            promptTemplate = """
//            You are an educational quiz generator that creates accurate, curriculum-appropriate quiz questions.
//            
//            Generate \(count) True/False questions about \(topic).
//            
//            Guidelines:
//            - Questions should be clear statements that are definitively either true or false
//            - Ensure factual accuracy
//            - Avoid ambiguous questions
//            
//            Return ONLY a JSON array with objects containing:
//            - "text": the question text
//            - "correctAnswer": a boolean (true or false)
//            
//            Example format:
//            [
//              {
//                "text": "The Earth orbits around the Sun.",
//                "correctAnswer": true
//              }
//            ]
//            """
//        case .multipleChoice:
//            promptTemplate = """
//            You are an educational quiz generator that creates accurate, curriculum-appropriate quiz questions.
//            
//            Generate \(count) Multiple Choice questions about \(topic).
//            
//            Guidelines:
//            - Each question should have exactly four options
//            - The correct answer must be one of the four options
//            - Make sure options are distinct and clear
//            
//            Return ONLY a JSON array with objects containing:
//            - "text": the question text
//            - "correctAnswer": the correct option as a string
//            - "choices": an array of 4 string options
//            
//            Example format:
//            [
//              {
//                "text": "Which planet is closest to the Sun?",
//                "correctAnswer": "Mercury",
//                "choices": ["Venus", "Mercury", "Earth", "Mars"]
//              }
//            ]
//            """
//        case .fillInTheBlank:
//            promptTemplate = """
//            You are an educational quiz generator that creates accurate, curriculum-appropriate quiz questions.
//            
//            Generate \(count) Fill in the Blank questions about \(topic).
//            
//            Guidelines:
//            - Include a blank represented by '_____' (five underscores) in the question text
//            - Ensure there's only one blank per question
//            - The answer should be a single word or short phrase
//            
//            Return ONLY a JSON array with objects containing:
//            - "text": the question text with '_____' for the blank
//            - "correctAnswer": the correct word or phrase (string)
//            
//            Example format:
//            [
//              {
//                "text": "The capital of France is _____.",
//                "correctAnswer": "Paris"
//              }
//            ]
//            """
//        case .shortAnswer:
//            promptTemplate = """
//            You are an educational quiz generator that creates accurate, curriculum-appropriate quiz questions.
//            
//            Generate \(count) Short Answer questions about \(topic).
//            
//            Guidelines:
//            - Questions should have brief, specific answers
//            - Keep answers to single words or short phrases
//            - Questions should be clear and focused
//            
//            Return ONLY a JSON array with objects containing:
//            - "text": the question text
//            - "correctAnswer": the correct answer (string)
//            
//            Example format:
//            [
//              {
//                "text": "What is the chemical symbol for gold?",
//                "correctAnswer": "Au"
//              }
//            ]
//            """
//        }
            
        let requestBody: [String: Any] = [
            "model": "o4-mini-2025-04-16",
            "messages": [
                [
                    "role": "user",
                    "content": "return a JSON with \(count) trivia style questions about \(topic) each entry having a string text and string correctAnswer"
                ]
            ]
        ]
        
        
        
        let jsonData = try JSONSerialization.data(withJSONObject: requestBody)
        request.httpBody = jsonData
        
//        let configuration = URLSessionConfiguration.default
//        configuration.timeoutIntervalForRequest = 180
//        configuration.timeoutIntervalForResource = 180
//        let session = URLSession(configuration: configuration)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NSError(domain: "OpenAIError", code: 2, userInfo: [NSLocalizedDescriptionKey: "InvalidResponse"])
        }
        
        print("Request Body Used: \(String(data: data, encoding:     .utf8) ?? "invalid")")
        
        guard httpResponse.statusCode == 200 else {
            let errorBody = String(data: data, encoding: .utf8) ?? "No data returned"
            throw NSError(domain: "OpenAIError", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Failed to generate quiz: \(errorBody)"])
        }
        
        let decoder = JSONDecoder()
        let responseData = try decoder.decode(OpenAIResponse.self, from: data)
        
        guard let contentString = responseData.choices.first?.message.content else {
            throw NSError(domain: "OpenAIError", code: 3, userInfo: [NSLocalizedDescriptionKey: "InvalidResponseFormat"])
        }
        
        let contentData = contentString.data(using: .utf8)!
        
        switch type {
        case .trueFalse:
            let tfQuestions = try decoder.decode([TFQuestion].self, from: contentData)
            return tfQuestions.map { data in
                    Question(
                        text: data.text,
                        type: .trueFalse,
                        correctAnswer: .boolean(data.correctAnswer)
                    )
            }
        case .multipleChoice:
            let mcQuestions = try decoder.decode([MCQuestion].self, from: contentData)
            return mcQuestions.map { data in
                    Question(
                        text: data.text,
                        type: .multipleChoice,
                        correctAnswer: .string(data.correctAnswer),
                        choices: data.choices
                    )
            }
        case .shortAnswer, .fillInTheBlank:
            let textQuestions = try decoder.decode([TextQuestion].self, from: contentData)
            return textQuestions.map { data in
                    Question(
                        text: data.text,
                        type: type,
                        correctAnswer: .string(data.correctAnswer)
                    )
            }
        }
    }
    
    private func questionTypeString(_ type: QuestionType) -> String {
        switch type {
        case .trueFalse:
            return "True/False"
        case .fillInTheBlank:
            return "Fill in the blank"
        case .multipleChoice:
            return "Multiple Choice"
        case .shortAnswer:
            return "Short Answer"
        }
    }
    
}

@MainActor
class QuizSession: ObservableObject {
    @Published var questions: [Question]
    @Published var currentQuestionIndex: Int
    @Published var isLoading: Bool = false
    @Published var error: String? = nil
    var topic: String
    var count: Int
    var type: QuestionType
    
    init(topic: String = "", count: Int = 5, type: QuestionType = QuestionType.trueFalse, questions: [Question] = []) {
        self.topic = topic
        self.count = count
        self.type = type
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
    
    func generateQuestions(topic: String, count: Int, type: QuestionType) async {
        guard !topic.isEmpty else {
            return
        }
        
        DispatchQueue.main.async {
            self.isLoading = true
            self.error = nil
        }
        
        do {
            let generatedQuestions = try await OpenAIService.shared.generateQuiz(topic: topic, count: count, type: type)
            
            DispatchQueue.main.async {
                self.questions = generatedQuestions
                self.isLoading = false
            }
        } catch {
            DispatchQueue.main.async {
                self.isLoading = false
                self.error = "Failed to generate questions: \(error.localizedDescription)"
            }
        }
        
    }
    
}

//struct QuestionGenerator {
//    static func generateQuestions(topic: String, count: Int, type: QuestionType) -> [Question] {
//        var questions: [Question] = []
//        
//        for i in 0..<count {
//            switch type {
//            case .trueFalse:
//                questions.append(Question(
//                    text: "Sample True/False Question \(i + 1)",
//                    type: .trueFalse,
//                    correctAnswer: .boolean(true)
//                ))
//            case .multipleChoice:
//                questions.append(Question(
//                    text: "Sample MCQ \(i + 1)",
//                    type: .multipleChoice,
//                    correctAnswer: .string("A"),
//                    choices: ["A", "B", "C", "D"]
//                ))
//            case .fillInTheBlank:
//                questions.append(Question(
//                    text: "Sample Fill in Blank \(i + 1) _____",
//                    type: .fillInTheBlank,
//                    correctAnswer: .string("answer")
//                ))
//            case .shortAnswer:
//                questions.append(Question(
//                    text: "Sample Short Answer \(i + 1)?",
//                    type: .shortAnswer,
//                    correctAnswer: .string("answer")
//                ))
//            }
//        }
//        return questions
//    }
//}




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
    @StateObject private var session = QuizSession(topic: "")
    @State private var isQuizReady: Bool = false
    
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
                
//                NavigationLink(
//                    destination: QuestionContainerView(
//                        session: QuizSession(
//                            topic: topic,
//                            questions: QuestionGenerator.generateQuestions(
//                                topic: topic,
//                                count: questionCount,
//                                type: selectedType
//                            )
//                        ),
//                        questionIndex: .constant(0)
//                    )
//                ) {
//                    Text("Start Quiz")
//                        .font(.title2)
//                        .padding()
//                        .background(Color.blue)
//                        .foregroundColor(.white)
//                        .cornerRadius(10)
//                }
//                .disabled(topic.isEmpty)
                
                Button(action: {
                    session.topic = self.topic
                    session.count = questionCount
                    session.type = selectedType
                    
                    Task {
                        await session.generateQuestions(topic: topic, count: questionCount, type: selectedType)
                        isQuizReady = !session.questions.isEmpty
                    }
                }) {
                    if session.isLoading {
                        ProgressView().progressViewStyle(CircularProgressViewStyle())
                    }
                    else {
                        Text("Generate Quiz")
                            .font(.title2)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }.disabled(topic.isEmpty || session.isLoading)
                
                if let error = session.error {
                    Text(error)
                        .foregroundColor(.red)
                        .padding()
                }
                
                if isQuizReady {
                    NavigationLink(
                        destination: QuestionContainerView(
                            session: session,
                            questionIndex: .constant(0)
                        )
                    ) {
                        Text("Start Quiz")
                            .font(.title2)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                
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
