import SwiftUI



struct View2: View {
    @State private var answerOne: String = ""
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
                
                
                .padding(10)
              
                let progressOne = progress.progressArray[0]
                
                Text(progressOne.question)
                    .padding(-10)
                
               
                
                
                HStack {
                    
                    TextField("Name",text: $answerOne)
                        .textFieldStyle(.roundedBorder)
                        .padding(9)
                        .background(Color(.systemBlue))
                        .cornerRadius(8)
                } .padding(15)
                
                Button(action: {
                    answerChecked = true
                    answerCorrect = answerOne.lowercased() == progressOne.correctAnswer
                    
                    progressOne.answerCorrect = answerCorrect
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
                    NavigationLink(destination: View3(answerOne: answerOne).navigationBarBackButtonHidden(true)){
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

struct View2_Previews: PreviewProvider {
    static var previews: some View {
        View2()
            .environmentObject(SharedData())
    }
}
