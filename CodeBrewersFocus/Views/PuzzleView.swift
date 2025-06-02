

import SwiftUI

struct PuzzleView: View{
    var body: some View {
        
        VStack(alignment: .leading) {
            
            
            
            
            
            Button(action: {
                
            }) {
                NavigationLink(destination: ColourPuzzleView()) {
                    Text("Continue")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
            }
            .padding(.horizontal)
            .padding(.top, 600)
        }
        .navigationTitle("Create your masterpeice")
        .navigationBarTitleDisplayMode(.inline)
    }
       
        
    }
#Preview {
    
    MainTabView()
}

