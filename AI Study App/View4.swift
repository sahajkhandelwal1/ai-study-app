//
//  View4.swift
//  AI Study App
//
//  Created by Sahaj on 10/27/24.
//

import SwiftUI

struct View4: View {
    var answerOne: String
    var answerTwo: String
    @State private var answerThree: Bool? = nil
    @State private var answerChecked: Bool = false
    @State private var answerCorrect: Bool? = nil
    @EnvironmentObject var progress: SharedData

    var body: some View {
        NavigationView {
            VStack {
                
                HStack {
                    
                    ForEach(progress.progressArray.indices,id:\.self) { index in
                        Rectangle()
                            .fill(
                                            progress.progressArray[index] == true ? .green : // Green if true
                                            progress.progressArray[index] == false ? .red : // Red if false
                                            .gray // Gray if nil
                                        )
                                        .frame(width: 30, height: 30)
                    }
                    
                }
                
                Text("My name is Sahaj")
                Menu{
                    Button(action: {
                        answerThree = true
                    }, label: {
                        Text("True")
                    })
                    Button(action: {
                        answerThree = false
                    }, label: {
                        Text("False")
                    })
                } label: {
                    Label(
                        title: { Text(answerThree == nil ? "True/False" : "\(answerThree! ? "True" : "False")")
                                                    .font(.title)
                                                    .foregroundStyle(.black)
                                                },
                        icon: {Image(systemName: "arrowtriangle.down.fill").foregroundStyle(.black).imageScale(.large)}
                    )
                }
                
                Button(action: {
                    answerChecked = true
                    answerCorrect = answerThree == true
                    
                    progress.progressArray[2] = answerCorrect

                    
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
                    NavigationLink(destination: View6(answerOne: answerOne, answerTwo: answerTwo, answerThree: answerThree).navigationBarBackButtonHidden(true)){
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


struct View4_Previews: PreviewProvider {
    static var previews: some View {
        View4(answerOne: "Sample Answer", answerTwo: "Sample Answer")
            .environmentObject(SharedData())
    }
}

