

import SwiftUI

struct ColourPuzzleView: View{
    @State private var selectedColor: Color = .black
    var body: some View {
        
        VStack(alignment: .leading) {
            
            
            Text("Select a colour")
                           .font(.subheadline)
                           .padding(.top, 8)
                           .padding(.leading)

                       ColourPickerView(selectedColor: $selectedColor)
            
            
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
            .padding(.bottom, 50)
        }
        .navigationTitle("Colour your creation")
        .navigationBarTitleDisplayMode(.inline)
    }
       
        
    }
#Preview {
    
    MainTabView()
}
