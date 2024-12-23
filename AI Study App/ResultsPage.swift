//
//  View4.swift
//  AI Study App
//
//  Created by Sahaj on 10/27/24.
//

import SwiftUI



struct ResultsPage: View {
    var answerOne: String
    var answerTwo: String
    var answerThree: Bool?
    var answerFour: String
    @EnvironmentObject var progress: SharedData
  
  
    
    var body: some View {
        NavigationView {
            VStack {
                
                
                HStack {
                    
                    ForEach(progress.progressArray.indices,id:\.self) { index in
                        Rectangle()
                            .fill(colorForAnswer(progress.progressArray[index].answerCorrect))
                                        .frame(width: 30, height: 30)
                    }
                    
                }
                
                VStack {
                    Text("You Scored")
                    Text(calculateScore(from: progress.progressArray))
                                            .font(.title)
                                            .foregroundColor(.blue)
                        
                  
                }
              

                
              
                }
            }
         
        }
    }

func calculateScore(from progressArray: [SharedData.ProgressData]) -> String {
    let trueCount = progressArray.filter{ $0.answerCorrect == true }.count
    let falseCount = progressArray.filter{ $0.answerCorrect == false }.count
    return "\(trueCount)/\(trueCount+falseCount)"
    
}



struct ResultsPage_Previews: PreviewProvider {
    static var previews: some View {
        ResultsPage(answerOne: "Sample Answer", answerTwo: "Sample Answer", answerThree: nil, answerFour: "Sample Answer")            .environmentObject(SharedData())
    }
}


