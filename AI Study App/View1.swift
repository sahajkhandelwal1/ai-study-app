//
//  View1.swift
//  AI Study App
//
//  Created by Sahaj on 11/3/24.
//

import SwiftUI

struct View1: View {
    @State private var topic: String = ""
    @State private var numQs: Int = 5
    @State private var choiceMade: String = "Question Type"
    @EnvironmentObject var progress: SharedData
  
    var body: some View {
        NavigationView() {
            VStack {
                
                HStack {
                    
                    ForEach(progress.progressArray.indices,id:\.self) { index in
                        Rectangle()
                            .fill(colorForAnswer(progress.progressArray[index].answerCorrect))
                                        .frame(width: 30, height: 30)
                    }
                    
                }
                
                .padding(.top) // Optional: Add padding at the top if you want some space from the edge
                
                Spacer() // Pushes the rest of the content down
                
                
                TextField("What Study Topic? (Ex: Solve Quadratics)",text: $topic)
                    .textFieldStyle(.roundedBorder)
                    .padding(9)
                    .background(Color(.systemBlue))
                    .cornerRadius(8)
                
                Stepper("Number of Questions: \(numQs)", value: $numQs, in: 5...20)
                
                
                
                
                Menu{
                    Button(action: {
                        choiceMade = "True/False"
                    }, label: {
                        Text("True/False")
                    })
                    Button(action: {
                        choiceMade = "Multiple Choice"
                    }, label: {
                        Text("Multiple Choice")
                    })
                    Button(action: {
                        choiceMade = "Fill in the Blank"
                    }, label: {
                        Text("Fill in the Blank")
                    })
                    Button(action: {
                        choiceMade = "Short Answer"
                    }, label: {
                        Text("Short Answer")
                    })
                } label: {
                    Label(
                        title: {Text("\(choiceMade)").font(.title).foregroundStyle(.black) },
                        icon: {Image(systemName: "arrowtriangle.down.fill").foregroundStyle(.black).imageScale(.large)}
                    )
                }
                
                .padding(5)
                
                NavigationLink(destination: View2()){
                    Text("Let's Go!")
                        .frame(width:170, height: 75, alignment: .center)
                        .background(Color.cyan)
                        .foregroundColor(Color.white)
                        .font(Font.system(size: 30))
                        .cornerRadius(20)
                }
                
            }
            
            .padding()
        }
    }
    
}

struct View1_Previews: PreviewProvider {
    static var previews: some View {
        View1()
            .environmentObject(SharedData()) // Provide SharedData instance directly to View1's preview
    }
}
