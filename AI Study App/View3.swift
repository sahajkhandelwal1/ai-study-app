//
//  View3.swift
//  AI Study App
//
//  Created by Sahaj on 10/27/24.
//

import SwiftUI

struct View3: View {
    var answerOne: String
    @State private var answerTwo: String = ""
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
                
                
                .padding(10)
                
                Text("My name is _____")
                TextField("Name",text: $answerTwo)
                    .textFieldStyle(.roundedBorder)
                    .padding(9)
                    .background(Color(.systemBlue))
                    .cornerRadius(8)
                
                Button(action: {
                    answerChecked = true
                    answerCorrect = answerTwo.lowercased() == "sahaj"
                    
                    progress.progressArray[1].answerCorrect = answerCorrect
                    
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
                    NavigationLink(destination: View4( answerOne: answerOne, answerTwo: answerTwo).navigationBarBackButtonHidden(true)){
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

struct View3_Previews: PreviewProvider {
    static var previews: some View {
        View3(answerOne: "Sample Answer")
            .environmentObject(SharedData())
    }
}
