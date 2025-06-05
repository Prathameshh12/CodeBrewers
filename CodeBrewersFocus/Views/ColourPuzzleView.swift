
import SwiftUI

struct PuzzlePieceCell: View {
    let piece: PuzzlePiece
    let selectedColor: Color

    var body: some View {
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

                RoundedRectangle(cornerRadius: 14)
                    .fill(selectedColor.opacity(0.3))
            } else {
                RoundedRectangle(cornerRadius: 14)
                    .stroke(style: StrokeStyle(lineWidth: 1, dash: [2]))
                    .foregroundColor(.gray.opacity(0.8))
            }
        }
        .frame(width: 68, height: 68)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct ColourPuzzleView: View{
    @EnvironmentObject var session: PuzzleSession
    @Binding var path: [String]

    var body: some View {
        VStack {
            VStack(spacing: 6) {
                ForEach(0..<6) { row in
                    HStack(spacing: 6) {
                        ForEach(0..<5) { col in
                            let index = row * 5 + col
                            if index < session.pieces.count {
                                PuzzlePieceCell(piece: session.pieces[index], selectedColor: session.selectedColor)
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

            ColourPickerView(selectedColor: $session.selectedColor)
                .padding(.top, -12)

// MARK: - Continue Button
            Button(action: {
                path.append("analysing")
            }) {
                Text("Continue")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(25)
            }
            .padding(.horizontal)
            .padding(.bottom, 18)
        }
        .navigationTitle("Colour your creation")
        .navigationBarTitleDisplayMode(.inline)
    }
}
#Preview {
    MainTabView()
}
