



import SwiftUI
import UniformTypeIdentifiers

struct PuzzlePiece: Identifiable, Hashable, Encodable, Decodable, Transferable {
    var id = UUID()
    let imageName: String
    var isInverted: Bool = false
    var rotation: Double = 0
    var flippedHorizontally: Bool = false
    var flippedVertically: Bool = false
    var isPlaceholder: Bool = false
    
    static var transferRepresentation: some TransferRepresentation {
            CodableRepresentation(contentType: .puzzlePiece)
        }
    }
extension UTType {
    static let puzzlePiece = UTType(exportedAs: "com.focusapp.puzzlepiece")
    }

struct PuzzleBlockView: View {
    let piece: PuzzlePiece
    let isSelected: Bool
    var onTap: () -> Void

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14)
                .fill(piece.isInverted ? .black : Color(white: 0.9))
            Image(piece.imageName)
                .resizable()
                .blendMode(piece.isInverted ? .difference : .normal)
                .rotationEffect(.degrees(piece.rotation))
                .scaleEffect(x: piece.flippedHorizontally ? -1 : 1, y: piece.flippedVertically ? -1 : 1)
                .frame(width: 68, height: 68)
        }
        .frame(width: 68, height: 68)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 3)
        )
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .onTapGesture(perform: onTap)
        .draggable(piece)
    }
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
                                Group {
                                    if piece.isPlaceholder {
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(style: StrokeStyle(lineWidth: 1, dash: [2]))
                                            .background(Color.clear)
                                            .contentShape(RoundedRectangle(cornerRadius: 8))
                                            .frame(width: 68, height: 68)
                                            .foregroundColor(.gray.opacity(0.8))
                                            .dropDestination(for: PuzzlePiece.self) { droppedItems, _ in
                                                guard let droppedPiece = droppedItems.first else { return false }
                                                if let sourceIndex = pieces.firstIndex(where: { $0.id == droppedPiece.id }) {
                                                    // Source is puzzle
                                                    if piece.isPlaceholder {
                                                        // Dropping into placeholder → move
                                                        pieces[sourceIndex] = PuzzlePiece(imageName: "", isPlaceholder: true)
                                                        pieces[index] = droppedPiece
                                                    } else {
                                                        // Swap positions
                                                        pieces.swapAt(sourceIndex, index)
                                                    }
                                                } else if let shelfIndex = onHoldShelf.firstIndex(where: { $0.id == droppedPiece.id }) {
                                                    if piece.isPlaceholder {
                                                        // Move from shelf → puzzle (remove from shelf)
                                                        onHoldShelf.remove(at: shelfIndex)
                                                        pieces[index] = droppedPiece
                                                    } else {
                                                        // Swap shelf <-> puzzle
                                                        let current = pieces[index]
                                                        pieces[index] = droppedPiece
                                                        onHoldShelf[shelfIndex] = current
                                                    }
                                                }
                                                    

                                                return true
                                            }
                                    } else {
                                        PuzzleBlockView(
                                            piece: piece,
                                            isSelected: selectedPieceID == piece.id,
                                            onTap: { selectedPieceID = piece.id }
                                        )
                                        .dropDestination(for: PuzzlePiece.self) { droppedItems, _ in
                                            guard let droppedPiece = droppedItems.first else { return false }

                                            if let sourceIndex = pieces.firstIndex(where: { $0.id == droppedPiece.id }) {
                                                pieces.swapAt(sourceIndex, index)
                                            }
                                            else if let shelfIndex = onHoldShelf.firstIndex(where: { $0.id == droppedPiece.id }) {
                                                let puzzlePiece = pieces[index]
                                                pieces[index] = droppedPiece
                                                onHoldShelf[shelfIndex] = puzzlePiece
                                            }
                                            return true
                                        }
                                    }
                                }
                                .dropDestination(for: PuzzlePiece.self) { droppedItems, _ in
                                    guard let droppedPiece = droppedItems.first else { return false }

                                    if let index = pieces.firstIndex(where: { $0.id == droppedPiece.id }) {
                                        // From puzzle to shelf → move
                                        let realPiece = pieces[index]
                                        onHoldShelf.append(realPiece)
                                        pieces[index] = PuzzlePiece(imageName: "", isPlaceholder: true)
                                        return true
                                    }
                                    return false
                                }
                            }
                        }
                    }
                }
            }
            .padding(.horizontal)
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

                    Image(systemName: "square.filled.on.square")
                        .foregroundColor(.black)
                        .opacity(isCopyFlashing ? 1.0 : 0.4)
                        .onTapGesture {
                                if let selectedID = selectedPieceID {
                                    if let originalPiece = pieces.first(where: { $0.id == selectedID }) {
                                        let copiedPiece = PuzzlePiece(imageName: originalPiece.imageName)
                                        onHoldShelf.append(copiedPiece)
                                    } else if let originalPiece = onHoldShelf.first(where: { $0.id == selectedID }) {
                                        let copiedPiece = PuzzlePiece(imageName: originalPiece.imageName)
                                        onHoldShelf.append(copiedPiece)
                                    }
                                }

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
                                if let selectedID = selectedPieceID {
                                    if let index = pieces.firstIndex(where: { $0.id == selectedID }) {
                                        withAnimation(.easeInOut(duration: .infinity)) {
                                            pieces[index].isInverted.toggle()
                                            isInvertFlashing = true
                                        }
                                    } else if let index = onHoldShelf.firstIndex(where: { $0.id == selectedID }) {
                                        withAnimation(.easeInOut(duration: .infinity)) {
                                            onHoldShelf[index].isInverted.toggle()
                                            isInvertFlashing = true
                                        }
                                    }

                                    // Reset flash effect
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
                                if let selectedID = selectedPieceID {
                                    if let index = pieces.firstIndex(where: { $0.id == selectedID }) {
                                        withAnimation(.easeInOut(duration: 0.2)) {
                                            pieces[index].rotation += 90
                                            if pieces[index].rotation >= 360 {
                                                pieces[index].rotation = 0
                                            }
                                            isRotateRightFlashing = true
                                        }
                                    } else if let index = onHoldShelf.firstIndex(where: { $0.id == selectedID }) {
                                        withAnimation(.easeInOut(duration: 0.2)) {
                                            onHoldShelf[index].rotation += 90
                                            if onHoldShelf[index].rotation >= 360 {
                                                onHoldShelf[index].rotation = 0
                                            }
                                            isRotateRightFlashing = true
                                        }
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
                            if let selectedID = selectedPieceID {
                                if let index = pieces.firstIndex(where: { $0.id == selectedID }) {
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        pieces[index].rotation -= 90
                                        if pieces[index].rotation >= 360 {
                                            pieces[index].rotation = 0
                                            }
                                            isRotateLeftFlashing = true
                                        }
                                    } else if let index = onHoldShelf.firstIndex(where: { $0.id == selectedID }) {
                                        withAnimation(.easeInOut(duration: 0.2)) {
                                            onHoldShelf[index].rotation -= 90
                                            if onHoldShelf[index].rotation >= 360 {
                                                onHoldShelf[index].rotation = 0
                                            }
                                            isRotateLeftFlashing = true
                                        }
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
                                if let selectedID = selectedPieceID {
                                    if let index = pieces.firstIndex(where: { $0.id == selectedID }) {
                                        withAnimation(.easeInOut(duration: 0.2)) {
                                            pieces[index].flippedHorizontally.toggle()
                                            isFlipHorizontally = true
                                        }
                                    } else if let index = onHoldShelf.firstIndex(where: { $0.id == selectedID }) {
                                        withAnimation(.easeInOut(duration: 0.2)) {
                                            onHoldShelf[index].flippedHorizontally.toggle()
                                            isFlipHorizontally = true
                                        }
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
                                if let selectedID = selectedPieceID {
                                    if let index = pieces.firstIndex(where: { $0.id == selectedID }) {
                                        withAnimation(.easeInOut(duration: 0.2)) {
                                            pieces[index].flippedVertically.toggle()
                                            isFlipVertically = true
                                        }
                                    } else if let index = onHoldShelf.firstIndex(where: { $0.id == selectedID }) {
                                        withAnimation(.easeInOut(duration: 0.2)) {
                                            onHoldShelf[index].flippedVertically.toggle()
                                            isFlipVertically = true
                                        }
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
                   .padding(.top, -8)
                   .padding(.bottom, -8)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(onHoldShelf) { piece in
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(piece.isInverted ? .black : Color(white: 0.9))
                                
                                Image(piece.imageName)
                                    .resizable()
                                    .blendMode(piece.isInverted ? .difference : .normal)
                                    .rotationEffect(.degrees(piece.rotation))
                                    .scaleEffect(x: piece.flippedHorizontally ? -1 : 1,
                                                 y: piece.flippedVertically ? -1 : 1)
                                    .frame(width: 68, height: 68)
                            }
                            .frame(width: 68, height: 68)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .overlay(
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(selectedPieceID == piece.id ? Color.blue : Color.clear, lineWidth: 3)
                            )
                            .scaleEffect(selectedPieceID == piece.id ? 1.05 : 1.0)
                            .onTapGesture {
                                selectedPieceID = piece.id
                            }
                            .draggable(piece)
                            .dropDestination(for: PuzzlePiece.self) { droppedItems, _ in
                                guard let droppedPiece = droppedItems.first else { return false }

                                if let fromIndex = onHoldShelf.firstIndex(where: { $0.id == droppedPiece.id }),
                                   let toIndex = onHoldShelf.firstIndex(where: { $0.id == piece.id }),
                                   fromIndex != toIndex {
                                    onHoldShelf.swapAt(fromIndex, toIndex)
                                    return true
                                }

                                return false
                            }
                        }

                        // Empty slots to drop into
                        ForEach(0..<(40 - onHoldShelf.count), id: \.self) { _ in
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(style: StrokeStyle(lineWidth: 1, dash: [2]))
                                    .background(Color.clear)
                                    .contentShape(RoundedRectangle(cornerRadius: 8))
                                    .frame(width: 68, height: 68)
                                    .foregroundColor(.gray.opacity(0.8))
                                    .dropDestination(for: PuzzlePiece.self) { droppedItems, _ in
                                        guard let droppedPiece = droppedItems.first else { return false }

                                        if !onHoldShelf.contains(where: { $0.id == droppedPiece.id }) {
                                            if let index = pieces.firstIndex(where: { $0.id == droppedPiece.id }) {
                                                let realPiece = pieces[index]
                                                onHoldShelf.append(realPiece)
                                                pieces[index] = PuzzlePiece(imageName: "", isPlaceholder: true)
                                            }

                                            // Replace puzzle piece with an empty slot
                                            if let index = pieces.firstIndex(where: { $0.id == droppedPiece.id }) {
                                                pieces[index] = PuzzlePiece(imageName: "", isPlaceholder: true)
                                            }
                                        }
                                        return true
                                    }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 4)
                }
                ZStack {
                    Image("Shelf")
                        .resizable()
                        .frame(width: 402, height: 25)
                }
                .shadow(color: .black.opacity(0.45), radius: 5, x: 0, y: 4)
                .padding(.top, -4)
            }
            
            Button(action: {
                
            }) {
                NavigationLink(destination: ColourPuzzleView(pieces: pieces)) {
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
            .padding(.bottom, 80)
          
          
        }
        .navigationTitle("Create your masterpeice")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
   MainTabView()
}




