import SwiftUI
// MARK: - Creating Snapshot of previous page
struct ColourPuzzleSnapshot: View {
    @EnvironmentObject var session: PuzzleSession
    
    var body: some View {
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
    }
}

// MARK: - Animation
struct AnalysingAnimation: View {
    @Binding var path: [String]

    var body: some View {
        ZStack {
            // Background
            ColourPuzzleSnapshot()
                            .blur(radius: 18)
                            .ignoresSafeArea()
            // Blur layer
            Color.white.opacity(0.6)
//                .background(.ultraThinMaterial)
                .ignoresSafeArea()
            
            //Animation
            PuzzleAnimation()
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                runFullCycle {
                    if path.last != "analysis" {
                        path.append("analysis")
                    }
                }
            }
        }
    }
}
// Animation Cycle
func runOneCycle(completion: @escaping () -> Void) {
    NotificationCenter.default.post(name: .runPuzzleCycle, object: nil)
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
        completion()
    }
}

// MARK: - Animation lines

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
                    .animation(.easeInOut(duration: 0.8), value: currentPositions)
            }
        }
        .frame(width: 100, height: 100)
        .onReceive(NotificationCenter.default.publisher(for: .runPuzzleCycle)) { _ in
            runCycle()
        }
    }
    func runCycle() {
        isExpanding = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.easeInOut(duration: 0.5)) {
                currentPositions = currentPositions.map { ($0 + 1) % 4 }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
            isExpanding = false
        }
    }
}
func runFullCycle(completion: @escaping () -> Void) {
    let cycleDuration: Double = 1.6
    let buffer: Double = 0.2 // tempo extra para a última animação terminar com suavidade

    for i in 0..<4 {
        DispatchQueue.main.asyncAfter(deadline: .now() + cycleDuration * Double(i)) {
            NotificationCenter.default.post(name: .runPuzzleCycle, object: nil)
        }
    }
    // Agora espera 6.4 + 0.4 = 6.8s antes de navegar
    DispatchQueue.main.asyncAfter(deadline: .now() + cycleDuration * 4 + buffer) {
        completion()
    }
}
            #Preview {
                MainTabView()
            }
    
extension Notification.Name {
    static let runPuzzleCycle = Notification.Name("runPuzzleCycle")
}
