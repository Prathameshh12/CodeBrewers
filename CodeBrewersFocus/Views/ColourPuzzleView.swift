

import SwiftUI

struct ColourPuzzleView: View{
    @State private var selectedColor: Color = .black
    var pieces: [PuzzlePiece] 
    var body: some View {
        
        VStack(alignment: .leading) {
            
    
            VStack(spacing: 6) {
                ForEach(0..<6) { row in
                    HStack(spacing: 6) {
                        ForEach(0..<5) { col in
                            let index = row * 5 + col
                            if index < pieces.count {
                                let piece = pieces[index]
                                
                                ZStack {
                                    RoundedRectangle(cornerRadius: 14)
                                        .fill(selectedColor)  // Use chosen color
                                    
                                    Image(piece.imageName)
                                        .resizable()
                                        .blendMode(piece.isInverted ? .difference : .normal)
                                        .rotationEffect(.degrees(piece.rotation))
                                        .scaleEffect(x: piece.flippedHorizontally ? -1 : 1, y: piece.flippedVertically ? -1 : 1)
                                        .frame(width: 68, height: 68)
                                    RoundedRectangle(cornerRadius: 14)
                                           .fill(selectedColor.opacity(0.4))
                                }
                                .frame(width: 68, height: 68)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                        }
                    }
                }
               
            }
            Text("Select a colour")
                           .font(.subheadline)
                           .padding(.top, 8)
                           .padding(.leading)

                       ColourPickerView(selectedColor: $selectedColor)
            .padding(.top)

            
            
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
