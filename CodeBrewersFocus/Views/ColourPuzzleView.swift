
import SwiftUI

struct PuzzlePieceCell: View {
    @Binding var piece: PuzzlePiece
    let selectedColor: Color

    var body: some View {
        ZStack {
            if !piece.isPlaceholder {
                RoundedRectangle(cornerRadius: 14)
                    .fill(fill(!piece.isInverted))
                Image(piece.imageName)
                    .renderingMode(.template)
                    .resizable()
                    .foregroundColor(fill(piece.isInverted))
                    .rotationEffect(.degrees(piece.rotation))
                    .scaleEffect(
                        x: piece.flippedHorizontally ? -1 : 1,
                        y: piece.flippedVertically ? -1 : 1
                    )
                    .frame(width: 68, height: 68)
            } else {
                RoundedRectangle(cornerRadius: 14)
                    .stroke(style: StrokeStyle(lineWidth: 1, dash: [2]))
                    .foregroundColor(.gray.opacity(0.8))
            }
        }
        .frame(width: 68, height: 68)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
    
    func fill(_ b: Bool) -> Color {
        let bright = selectedColor.brightened()
        let dark = selectedColor
        return b ? bright : dark
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
                                PuzzlePieceCell(piece: $session.pieces[index], selectedColor: session.selectedColor)
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


extension Color {
    /// Returns a brightened version of the color by blending it with white.
    /// - Parameter amount: 0 = original, 1 = white, 0.5 = halfway to white
    func brightened(_ amount: Double = 0.9) -> Color {
        // Get UIColor (for RGB extraction, works for iOS and macOS Catalyst)
        #if canImport(UIKit)
        let uiColor = UIColor(self)
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        guard uiColor.getRed(&r, green: &g, blue: &b, alpha: &a) else { return self }
        #else
        // For macOS (AppKit)
        let nsColor = NSColor(self)
        guard let rgbColor = nsColor.usingColorSpace(.deviceRGB) else { return self }
        let r = rgbColor.redComponent
        let g = rgbColor.greenComponent
        let b = rgbColor.blueComponent
        let a = rgbColor.alphaComponent
        #endif
        
        // Interpolate each channel toward white (1.0)
        let newR = r + (1.0 - r) * CGFloat(amount)
        let newG = g + (1.0 - g) * CGFloat(amount)
        let newB = b + (1.0 - b) * CGFloat(amount)
        return Color(red: Double(newR), green: Double(newG), blue: Double(newB), opacity: Double(a))
    }
}

#Preview {
    MainTabView()
}

