


import SwiftUI

struct PuzzlePiece: Identifiable, Hashable {
    let id = UUID()
    let imageName: String
    var isInverted: Bool = false
    var rotation: Double = 0
    var flippedHorizontally: Bool = false
    var flippedVertically: Bool = false
}

struct PuzzleView: View {
    @State private var pieces: [PuzzlePiece] = (1...30).map {
            PuzzlePiece(imageName: String(format: "Wave-%02d", $0))
        }
    
    //For tool box
    @State private var selectedPieceID: UUID? = nil
    @State private var isCopyFlashing: Bool = false
    @State private var isInvertFlashing: Bool = false
    @State private var isRotateRightFlashing: Bool = false
    @State private var isRotateLeftFlashing: Bool = false
    @State private var isFlipHorizontally: Bool = false
    @State private var isFlipVertically: Bool = false
    
    //For On hold shelf
    @State private var onHoldShelf: [PuzzlePiece] = []
    
    
    var body: some View {
        VStack {
            
            
            //Puzzle
            VStack(spacing: 6) {
                ForEach(0..<6) { row in
                    HStack(spacing: 6) {
                        ForEach(0..<5) { col in
                            let index = row * 5 + col
                            if index < pieces.count {
                                let pieceBinding = $pieces[index]
                                let piece = pieceBinding.wrappedValue
                                
                                let puzzleBlock = ZStack {
                                    RoundedRectangle(cornerRadius: 14)
                                        .fill(pieceBinding.isInverted.wrappedValue ? .black : Color(white: 0.9))
                                    
                                    Image(piece.imageName)
                                        .resizable()
                                        .blendMode(pieceBinding.isInverted.wrappedValue ? .difference : .normal)
                                        .rotationEffect(.degrees(piece.rotation))
                                        .scaleEffect(x: piece.flippedHorizontally ? -1 : 1, y: piece.flippedVertically ? -1 : 1)
                                        .frame(width: 68, height: 68)
                                    //
                                }
                                
                                puzzleBlock
                                    .frame(width: 68, height: 68)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .overlay(RoundedRectangle(cornerRadius: 10)
                                        .stroke(selectedPieceID == piece.id ? Color.blue : Color.clear, lineWidth: 3)
                                    )
                                    .scaleEffect(selectedPieceID == piece.id ? 1.05 : 1.0)
                                    .onTapGesture {
                                        selectedPieceID = piece.id
                                    }
                                    .onDrag {selectedPieceID = piece.id
                                        return NSItemProvider(object: piece.imageName as NSString)
                                    }
                            }
                        }
                    }
                }
            }
            .padding(.top, 70)
            
            //Tool Box
            ZStack{
                Capsule()
                    .fill(Color.gray)
                    .opacity(0.1)
                    .frame(width: 370, height: 40)
                HStack(spacing: 24) {
                    Text("Toolbox")
                        .font(.subheadline)
                        .foregroundColor(.black.opacity(0.6))
                    // Spacer()
                    Image(systemName: "square.filled.on.square")
                        .foregroundColor(.black)
                        .opacity(isCopyFlashing ? 1.0 : 0.4)
                        .onTapGesture {
                            if let selectedID = selectedPieceID,
                               let originalPiece = pieces.first(where: { $0.id == selectedID }) {
                                let copiedPiece = PuzzlePiece(imageName: originalPiece.imageName)
                                onHoldShelf.append(copiedPiece)
                            }
                            
                            // Animate opacity change
                            withAnimation {
                                isCopyFlashing = true
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                withAnimation {
                                    isCopyFlashing = false
                                }
                            }
                        }
                    
                    Image(systemName: "drop.circle.fill")
                        .foregroundColor(.black)
                        .opacity(isInvertFlashing ? 1.0 : 0.4)
                        .onTapGesture {
                            if let selectedID = selectedPieceID,
                               let index = pieces.firstIndex(where: { $0.id == selectedID }) {
                                withAnimation(.easeInOut(duration: .infinity)) {
                                    $pieces[index].isInverted.wrappedValue.toggle()
                                    isInvertFlashing = true
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    withAnimation {
                                        isInvertFlashing = false
                                    }
                                }
                            }
                        }
                    
                    Image(systemName: "arrow.trianglehead.clockwise.rotate.90")
                        .foregroundColor(.black)
                        .opacity(isRotateRightFlashing ? 1.0 : 0.4)
                        .onTapGesture {
                            if let selectedID = selectedPieceID,
                               let index = pieces.firstIndex(where: { $0.id == selectedID }) {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                   pieces[index].rotation += 90
                                    if pieces[index].rotation >= 360 {
                                        pieces[index].rotation = 0
                                    }
                                    isRotateRightFlashing = true
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    withAnimation {
                                        isRotateRightFlashing = false
                                    }
                                }
                            }
                        }
                    
                    Image(systemName: "arrow.trianglehead.counterclockwise.rotate.90")
                        .foregroundColor(.black)
                        .opacity(isRotateLeftFlashing ? 1.0 : 0.4)
                        .onTapGesture {
                            if let selectedID = selectedPieceID,
                               let index = pieces.firstIndex(where: { $0.id == selectedID }) {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                   pieces[index].rotation -= 90
                                    if pieces[index].rotation < 0 {
                                        pieces[index].rotation += 360
                                    }
                                    isRotateLeftFlashing = true
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    withAnimation {
                                        isRotateLeftFlashing = false
                                    }
                                }
                            }
                        }
                    
                    Image(systemName: "arrow.trianglehead.left.and.right.righttriangle.left.righttriangle.right.fill")
                        .foregroundColor(.black)
                        .opacity(isFlipHorizontally ? 1.0 : 0.4)
                        .onTapGesture {
                            if let selectedID = selectedPieceID,
                               let index = pieces.firstIndex(where: { $0.id == selectedID }) {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    pieces[index].flippedHorizontally.toggle()
                                    isFlipHorizontally = true
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    withAnimation {
                                        isFlipHorizontally = false
                                    }
                                }
                            }
                        }
                    
                    Image(systemName: "arrow.trianglehead.up.and.down.righttriangle.up.righttriangle.down.fill")
                        .foregroundColor(.black)
                        .opacity(isFlipVertically ? 1.0 : 0.4)
                        .onTapGesture {
                            if let selectedID = selectedPieceID,
                               let index = pieces.firstIndex(where: { $0.id == selectedID }) {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    pieces[index].flippedVertically.toggle()
                                    isFlipVertically = true
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    withAnimation {
                                        isFlipVertically = false
                                    }
                                }
                            }
                        }
                }
                .padding(.vertical)
                .padding(.horizontal)
            }
            
            // On hold Shelf
            VStack(alignment: .leading) {
                Text("On hold shelf")
                    .font(.subheadline)
                    .foregroundColor(.black.opacity(0.6))
                    .padding(.horizontal)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(onHoldShelf) { piece in
                            Image(piece.imageName)
                                .resizable()
                                .frame(width: 68, height: 68)
                        }
                        
                        // Empty slots to drop into
                        ForEach(0..<(40 - onHoldShelf.count), id: \.self) { _ in
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(style: StrokeStyle(lineWidth: 1, dash: [2]))
                                .frame(width: 68, height: 68)
                                .foregroundColor(.gray.opacity(0.8))
                                .onDrop(of: [.text], isTargeted: nil) { providers in
                                    if let provider = providers.first {
                                        _ = provider.loadObject(ofClass: NSString.self) { object, _ in
                                            if let name = object as? String {
                                                DispatchQueue.main.async {
                                                    if let droppedPiece = pieces.first(where: { $0.imageName == name }) {
                                                        onHoldShelf.append(droppedPiece)
                                                        pieces.removeAll { $0.id == droppedPiece.id }
                                                    }
                                                }
                                            }
                                        }
                                        return true
                                    }
                                    return false
                                }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 4)
                }
                ZStack {
                    Image("Shelf")
                        .resizable()
                        .frame(width: 402, height: 20)
                }
                .shadow(color: .black.opacity(0.45), radius: 5, x: 0, y: 4)
                .padding(.top, -4)
            }
            
            Button(action: {
                
            }) {
                NavigationLink(destination: ColourPuzzleView(pieces: pieces)) {
                    Text("Continue")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 80)
          
          
        }
        .navigationTitle("Create your masterpeice")
        .navigationBarTitleDisplayMode(.inline)
       
        
    }
}

#Preview {
    MainTabView()
}

