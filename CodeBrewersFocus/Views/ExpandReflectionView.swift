
import SwiftUI

struct ExpandReflectionView: View {
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.gray, Color.white]), startPoint: .top, endPoint: .bottom)
            VStack{
                Text("March 12, 2025")
                Text("Wave")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                HStack{
                    Button("Flow") {
                    }
                    .foregroundStyle(Color.black)
                    .buttonStyle(BorderedProminentButtonStyle())
                    .tint(Color.white)
                    Button("Adaptability") {
                    }
                    .foregroundStyle(Color.black)
                    .buttonStyle(BorderedProminentButtonStyle())
                    .tint(Color.white)
                }
            
        
                HStack{
                    Toggle(isOn: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Is On@*/.constant(true)/*@END_MENU_TOKEN@*/) {
                    }
                    .padding(.horizontal, 50)
                    Text("Visible in Explore")
                        .padding(.horizontal, 20)
                }
                Text("Your Reflection")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Text("I realise that focus isn’t about holding still. It’s about flowing steadily in one direction, like a wave. I want to stay in the flow and not get distracted by everything around me.")

            }
                          
        }
        .padding()
    }
}

#Preview {
    ExpandReflectionView()
}
