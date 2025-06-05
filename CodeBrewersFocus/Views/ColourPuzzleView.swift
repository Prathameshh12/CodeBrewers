
import SwiftUI

struct ColourPuzzleView: View{
    @State private var selectedColor: Color = .clear
    var pieces: [PuzzlePiece]
    var body: some View {
        
// MARK: - Puzzle
        VStack {
            VStack(spacing: 6) {
                ForEach(0..<6) { row in
                    HStack(spacing: 6) {
                        ForEach(0..<5) { col in
                            let index = row * 5 + col
                            if index < pieces.count {
                                let piece = pieces[index]
                                ZStack {
                                    if !piece.isPlaceholder {
                                        Image(piece.imageName)
                                                                                .resizable()
                                                                                .blendMode(piece.isInverted ? .difference : .normal)
                                                                                .rotationEffect(.degrees(piece.rotation))
                                                                                .scaleEffect(
                                                                                    x: piece.flippedHorizontally ? -1 : 1,
                                                                                    y: piece.flippedVertically ? -1 : 1
                                                                                )
                                                                                .frame(width: 68, height: 68)
                                                                            
                                                                            // Only apply the colour overlay if it’s a real piece
                                                                            RoundedRectangle(cornerRadius: 14)
                                                                                .fill(selectedColor.opacity(0.3))
                                                                        } else {
                                                                            // For placeholders, you might show an empty or dashed border
                                                                            RoundedRectangle(cornerRadius: 14)
                                                                                .stroke(style: StrokeStyle(lineWidth: 1, dash: [2]))
                                                                                .foregroundColor(.gray.opacity(0.8))
                                                                        }
                                                                    }
                                                                    .frame(width: 68, height: 68)
                                                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                                                   
                                                                }
                                                                   
                                                            }
                                                        }
                                                        
                                                    }
                                                    
                                                   
                                                }
            .padding(.horizontal)
            .padding(.top, 30)
// MARK: - Colour Picker
            Text("Select a colour")
                .font(.subheadline)
                .foregroundColor(.black.opacity(0.6))
                .padding(.horizontal)
                .padding(.top, 8)

            ColourPickerView(selectedColor: $selectedColor)
                .padding(.top, -12)
            
// MARK: - Continue Button
            Button(action: {
                
            }) {
                NavigationLink(destination: AnalysingAnimation()) {
                    Text("Continue")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(25)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
        }
        .navigationTitle("Colour your creation")
        .navigationBarTitleDisplayMode(.inline)
       
    }
    }
#Preview {
    MainTabView()
}
