
import SwiftUI

struct ExpandReflectionView: View {
    @State private var isVisibleInExplore = true
    var body: some View {
        
        ScrollView{
            ZStack {
                
                VStack{
                    Text("March 12, 2025")
                        .padding(.bottom, -10)
                    Text("Wave")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding()
                    HStack(spacing: 10) {
                        Text("Flow")
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.gray.opacity(0.2))
                            .foregroundColor(.black)
                            .cornerRadius(20)
                        
                        Text("Adaptability")
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.gray.opacity(0.2))
                            .foregroundColor(.black)
                            .cornerRadius(20)
                    }
                
                    Spacer()
                    
                    
                    HStack{
                        Toggle("Visible in Explore", isOn: $isVisibleInExplore)
                            .toggleStyle(SwitchToggleStyle(tint: .green))
                            .foregroundColor(.black)
                            
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                   
                    
                    VStack(alignment: .leading, spacing: 8){
                        Text("Your Reflection")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text("I realise that focus isn’t about holding still. It’s about flowing steadily in one direction, like a wave. I want to stay in the flow and not get distracted by everything around me.")
                            .font(.body)
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                    
                }
                
                
                
            }
        }
       
    }
}

#Preview {
    MainTabView()
}
