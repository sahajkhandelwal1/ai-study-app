//
//  ContentView.swift
//  AI Study App
//
//  Created by Sahaj on 10/20/24.
//

import SwiftUI

class SharedData: ObservableObject {
    struct ProgressData {
        var question: String
        var userAnswer: String?
        var correctAnswer: AnswerType
        var answerCorrect: Bool?
        
        enum AnswerType {
            case boolean(Bool)
            case string(String)
        }
    }

    @Published var progressArray: [ProgressData] = [ProgressData(question: "What is your name?", correctAnswer:.string("Sahaj"), answerCorrect: nil), ProgressData(question: "My name is _____", correctAnswer:.string("Sahaj"), answerCorrect: nil), ProgressData(question: "My name is Sahaj", correctAnswer:.boolean(true), answerCorrect: nil), ProgressData(question: "My name is", correctAnswer:.string("Sahaj"), answerCorrect: nil)]
    
}

struct ContentView: View {

    @StateObject private var progress = SharedData()
    var body: some View {
        NavigationView{
            View1().environmentObject(progress)
            }
         
        }
        }
        

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(SharedData()) // Provide SharedData instance directly to View1's preview
    }
}

