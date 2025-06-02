

import SwiftUI

struct ColourPuzzleView: View{
    var body: some View {
        
        VStack(alignment: .leading) {
            
            
            
            
            
            Button(action: {
                
            }) {
                NavigationLink(destination: WriteReflectionView()) {
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
        .navigationTitle("Colour your creation")
        .navigationBarTitleDisplayMode(.inline)
    }
       
        
    }
#Preview {
    
    MainTabView()
}
