import SwiftUI

struct AnalysingAnimation: View {
    var body: some View {
        
//OVERALL STRUCTURE
        ZStack {
            
// SUBSTITUTE HERE FOR THE PREVIOUS SCREEN (IT'S IMAGE NOW JUST TO TEST THE BLUR LAYER)
            Image("Example-Analysing-Screen")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
// BLUR LAYER
            Color.white.opacity(0.6)
                .background(.ultraThinMaterial)
                .ignoresSafeArea()
            
// ANIMATION POSITION
            PuzzleAnimation()
        }
    }
}

// MARK: - ANIMATION CODE
struct PuzzleAnimation: View {
    let pieceNames = ["Logo-piece1", "Logo-piece2", "Logo-piece3", "Logo-piece4"]
    
    let gridPositions: [CGPoint] = [
        CGPoint(x: 0, y: 0), CGPoint(x: 1, y: 0),
        CGPoint(x: 1, y: 1), CGPoint(x: 0, y: 1)
    ]
    
    let offsetDirections: [CGSize] = [
        CGSize(width: -10, height: -10),
        CGSize(width:  10, height: -10),
        CGSize(width:  10, height:  10),
        CGSize(width: -10, height:  10)
    ]
    
    @State private var currentPositions: [Int] = [0, 1, 2, 3]
    @State private var isExpanding = false

    var body: some View {
        ZStack {
            ForEach(0..<4, id: \.self) { i in
                let gridIndex = currentPositions[i]
                let base = gridPositions[gridIndex]
                let offset = isExpanding ? offsetDirections[gridIndex] : .zero
                
                let spacing: CGFloat = 60
                let x = base.x * spacing + spacing / 2 + offset.width
                let y = base.y * spacing + spacing / 2 + offset.height
                
                Image(pieceNames[i])
                    .resizable()
                    .frame(width: 50, height: 50)
                    .cornerRadius(10)
                    .position(x: x, y: y)
                    .animation(.easeInOut(duration: 0.3), value: isExpanding)
                    .animation(.easeInOut(duration: 1.0), value: currentPositions)
            }
        }
        .frame(width: 120, height: 120)
        .onAppear {
            runCycle()
        }
    }

    func runCycle() {
        Timer.scheduledTimer(withTimeInterval: 1.6, repeats: true) { _ in
            isExpanding = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(.easeInOut(duration: 1.0)) {
                    currentPositions = currentPositions.map { ($0 + 1) % 4 }
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
                isExpanding = false
            }
        }
    }
}

#Preview {
    MainTabView()
}
