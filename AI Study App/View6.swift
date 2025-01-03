//
//  View4.swift
//  AI Study App
//
//  Created by Sahaj on 10/27/24.
//

import SwiftUI

struct View6: View {
    var answerOne: String
    var answerTwo: String
    var answerThree: Bool?
    @State private var answerFour: String = "_____"
    @State private var answerChecked: Bool = false
    @State private var answerCorrect: Bool? = nil
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
                
                HStack {
                    Text("My name is")
                        
                    Text("\(answerFour)")
                        .underline()
                }
         //style the buttons   
                HStack {
                    Button(action: {
                        answerFour = "Sahaj"
                    }, label: {
                        Text("Sahaj")
                    })
                    .buttonStyle(.bordered)

                    
                    
                    Button(action: {
                        answerFour = "Bob"
                    }, label: {
                        Text("Bob")
                    })
                    .buttonStyle(.bordered)

                }
                
                HStack {
                    Button(action: {
                        answerFour = "Sam"
                    }, label: {
                        Text("Sam")
                    })
                    .buttonStyle(.bordered)

                    
                    Button(action: {
                        answerFour = "Billy"
                    }, label: {
                        Text("Billy")
                    })
                    .buttonStyle(.bordered)

              
                }
                .padding(7)

                
                Button(action: {
                    answerChecked = true
                    answerCorrect = answerFour == "Sahaj"
                    
                    progress.progressArray[3].answerCorrect = answerCorrect
                    
                }, label: {
                    Text("Check Answer")
                }).disabled(answerChecked)
                
                if answerCorrect == true{
                    Text("Correct!")
                }
                else if answerCorrect == false{
                    Text("Incorrect")
                }
                
                if answerChecked{
                    NavigationLink(destination: ResultsPage( answerOne: answerOne, answerTwo: answerTwo, answerThree: answerThree, answerFour: answerFour).navigationBarBackButtonHidden(true)){
                        Text("Next")
                            .frame(width:110, height: 75, alignment: .center)
                            .background(Color.cyan)
                            .foregroundColor(Color.white)
                            .font(Font.system(size: 30))
                            .cornerRadius(20)
                    }

                }
            }
         
        }
    }

}


struct View6_Previews: PreviewProvider {
    static var previews: some View {
        View6(answerOne: "Sample Answer", answerTwo: "Sample Answer", answerThree: nil)            .environmentObject(SharedData())
    }
}


