
import SwiftUI
import UniformTypeIdentifiers
import Foundation


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
    static let puzzlePiece = UTType(exportedAs: "com.singular.puzzlepiece")
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
    
    @EnvironmentObject var session: PuzzleSession
    @Binding var path: [String]
    
// for draft saving
    @State private var showingSaveAlert = false
    @State private var showSavedMessage = false

// MARK: - For Back button
    @Environment(\.presentationMode) var presentationMode
    @State private var showExitPopup = false
    
// MARK: - For Puzzle
    @State private var pieces: [PuzzlePiece] = (1...30).map {
        PuzzlePiece(imageName: String(format: "Wave-%02d", $0))
    }
    
// MARK: - For tool box
    @State private var selectedPieceID: UUID? = nil
    @State private var isCopyFlashing: Bool = false
    @State private var isInvertFlashing: Bool = false
    @State private var isRotateRightFlashing: Bool = false
    @State private var isRotateLeftFlashing: Bool = false
    @State private var isFlipHorizontally: Bool = false
    @State private var isFlipVertically: Bool = false
    
// MARK: - For On hold shelf
    @State private var onHoldShelf: [PuzzlePiece] = []
 
// MARK: - Main Part
    var body: some View {
        
        VStack {
            
            PuzzleGrid
            toolBox
            onHoldShelfView
            navigationButtons
            
        }
    }
        
            
            // MARK: - Puzzle
        var PuzzleGrid: some View {
                VStack {
                    // MARK: - Puzzle Grid
                    VStack(spacing: 6) {
                        ForEach(0..<6) { row in
                            HStack(spacing: 6) {
                                ForEach(0..<5) { col in
                                    let index = row * 5 + col
                                    if index < session.pieces.count {
                                        PuzzleCellView(
                                            index: index,
                                            piece: session.pieces[index],
                                            onHoldShelf: $onHoldShelf,
                                            selectedPieceID: $selectedPieceID
                                        )
                                    }
                                }
                            }
                        }
                    }
                    .onAppear {
                
                        if session.isNewPuzzle {
                            return
                        }

                        // Load from latest draft only if not manually started
                        let drafts = PuzzleDraftManager.shared.loadDrafts()
                        if let latestDraft = drafts.last {
                            session.pieces = latestDraft.pieces
                        } else {
                            session.pieces = (1...30).map {
                                PuzzlePiece(imageName: String(format: "Wave-%02d", $0))
                            }
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top, 30)
            }
        struct PuzzleCellView: View {
            let index: Int
            let piece: PuzzlePiece
            @Binding var onHoldShelf: [PuzzlePiece]
            @Binding var selectedPieceID: UUID?
            
            @EnvironmentObject var session: PuzzleSession

            var body: some View {
                Group {
                    if piece.isPlaceholder {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(style: StrokeStyle(lineWidth: 1, dash: [2]))
                            .background(Color.clear)
                            .contentShape(RoundedRectangle(cornerRadius: 8))
                            .frame(width: 68, height: 68)
                            .foregroundColor(.gray.opacity(0.8))
                            .dropDestination(for: PuzzlePiece.self) { droppedItems, _ in
                                handleDrop(droppedItems)
                            }
                    } else {
                        PuzzleBlockView(
                            piece: piece,
                            isSelected: selectedPieceID == piece.id,
                            onTap: { selectedPieceID = piece.id }
                        )
                        .dropDestination(for: PuzzlePiece.self) { droppedItems, _ in
                            handleDrop(droppedItems)
                        }
                    }
                }
                .dropDestination(for: PuzzlePiece.self) { droppedItems, _ in
                    guard let droppedPiece = droppedItems.first else { return false }
                    if let fromIndex = session.pieces.firstIndex(where: { $0.id == droppedPiece.id }) {
                        onHoldShelf.append(session.pieces[fromIndex])
                        session.pieces[fromIndex] = PuzzlePiece(imageName: "", isPlaceholder: true)
                        return true
                    }
                    return false
                }
            }

            private func handleDrop(_ droppedItems: [PuzzlePiece]) -> Bool {
                guard let droppedPiece = droppedItems.first else { return false }

                if let sourceIndex = session.pieces.firstIndex(where: { $0.id == droppedPiece.id }) {
                    if piece.isPlaceholder {
                        session.pieces[sourceIndex] = PuzzlePiece(imageName: "", isPlaceholder: true)
                        session.pieces[index] = droppedPiece
                    } else {
                        session.pieces.swapAt(sourceIndex, index)
                    }
                } else if let shelfIndex = onHoldShelf.firstIndex(where: { $0.id == droppedPiece.id }) {
                    if piece.isPlaceholder {
                        onHoldShelf.remove(at: shelfIndex)
                        session.pieces[index] = droppedPiece
                    } else {
                        let current = session.pieces[index]
                        session.pieces[index] = droppedPiece
                        onHoldShelf[shelfIndex] = current
                    }
                }
                return true
            }
        }

                                
            // MARK: - Tool Box
            var toolBox: some View {
                ZStack{
                    Capsule()
                        .fill(Color.gray)
                        .opacity(0.1)
                        .frame(width: 370, height: 40)
                    HStack(spacing: 24) {
                        Text("Toolbox")
                            .font(.subheadline)
                            .foregroundColor(.black.opacity(0.6))
                        // MARK: - Copy
                        Image(systemName: "square.filled.on.square")
                            .foregroundColor(.black)
                            .opacity(isCopyFlashing ? 1.0 : 0.4)
                            .onTapGesture {
                                if let selectedID = selectedPieceID {
                                    if let originalPiece = session.pieces.first(where: { $0.id == selectedID }) {
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
                        // MARK: - Invert Color
                        Image(systemName: "drop.circle.fill")
                            .foregroundColor(.black)
                            .opacity(isInvertFlashing ? 1.0 : 0.4)
                            .onTapGesture {
                                if let selectedID = selectedPieceID {
                                    if let index = session.pieces.firstIndex(where: { $0.id == selectedID }) {
                                        withAnimation(.easeInOut(duration: .infinity)) {
                                            session.pieces[index].isInverted.toggle()
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
                        // MARK: - Clockwise Rotate
                        Image(systemName: "arrow.trianglehead.clockwise.rotate.90")
                            .foregroundColor(.black)
                            .opacity(isRotateRightFlashing ? 1.0 : 0.4)
                            .onTapGesture {
                                if let selectedID = selectedPieceID {
                                    if let index = session.pieces.firstIndex(where: { $0.id == selectedID }) {
                                        withAnimation(.easeInOut(duration: 0.2)) {
                                            session.pieces[index].rotation += 90
                                            if session.pieces[index].rotation >= 360 {
                                                session.pieces[index].rotation = 0
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
                        // MARK: - Counterclockwise Rotate
                        Image(systemName: "arrow.trianglehead.counterclockwise.rotate.90")
                            .foregroundColor(.black)
                            .opacity(isRotateLeftFlashing ? 1.0 : 0.4)
                            .onTapGesture {
                                if let selectedID = selectedPieceID {
                                    if let index = session.pieces.firstIndex(where: { $0.id == selectedID }) {
                                        withAnimation(.easeInOut(duration: 0.2)) {
                                            session.pieces[index].rotation -= 90
                                            if session.pieces[index].rotation >= 360 {
                                                session.pieces[index].rotation = 0
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
                        // MARK: - Horizontal Flip
                        Image(systemName: "arrow.trianglehead.left.and.right.righttriangle.left.righttriangle.right.fill")
                            .foregroundColor(.black)
                            .opacity(isFlipHorizontally ? 1.0 : 0.4)
                            .onTapGesture {
                                if let selectedID = selectedPieceID {
                                    if let index = session.pieces.firstIndex(where: { $0.id == selectedID }) {
                                        withAnimation(.easeInOut(duration: 0.2)) {
                                            session.pieces[index].flippedHorizontally.toggle()
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
                        // MARK: - Vertical Flip
                        Image(systemName: "arrow.trianglehead.up.and.down.righttriangle.up.righttriangle.down.fill")
                            .foregroundColor(.black)
                            .opacity(isFlipVertically ? 1.0 : 0.4)
                            .onTapGesture {
                                if let selectedID = selectedPieceID {
                                    if let index = session.pieces.firstIndex(where: { $0.id == selectedID }) {
                                        withAnimation(.easeInOut(duration: 0.2)) {
                                            session.pieces[index].flippedVertically.toggle()
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
            }
            // MARK: - On hold Shelf
            var onHoldShelfView: some View {
                VStack(alignment: .leading) {
                    Text("On hold shelf")
                        .font(.subheadline)
                        .foregroundColor(.black.opacity(0.6))
                        .padding(.horizontal)
                    
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
                                            if let index = session.pieces.firstIndex(where: { $0.id == droppedPiece.id }) {
                                                let realPiece = session.pieces[index]
                                                onHoldShelf.append(realPiece)
                                                session.pieces[index] = PuzzlePiece(imageName: "", isPlaceholder: true)
                                            }
                                            
                                            // Replace puzzle piece with an empty slot
                                            if let index = session.pieces.firstIndex(where: { $0.id == droppedPiece.id }) {
                                                session.pieces[index] = PuzzlePiece(imageName: "", isPlaceholder: true)
                                            }
                                        }
                                        return true
                                    }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 4)
                    }
                    HStack {
                        Spacer()
                        Image("Shelf")
                            .resizable()
                            .frame(width: 390, height: 25)
                            .opacity(0.6)
                    }
                    .shadow(color: .black.opacity(0.45), radius: 5, x: 0, y: 4)
                    .padding(.top, -4)
                }
            }
            // MARK: - Continue Button
            var navigationButtons: some View {
                Button(action: {
                    path.append("colour")
                    
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
                .padding(.bottom, 20)
                
                // MARK: - Back Button Pop-up
                .navigationBarBackButtonHidden(true)
                .navigationTitle("Create your masterpeice")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            showExitPopup = true
                        }) {
                            HStack {
                                Image(systemName: "chevron.left")
                                Text("Back")
                            }
                        }
                    }
                }
                .confirmationDialog(
                    "Leaving already?",
                    isPresented: $showExitPopup,
                    titleVisibility: .visible
                ) {
                    Button("Save draft") {
                        // Save logic here
                        PuzzleDraftManager.shared.saveDraft(session.pieces)
                        presentationMode.wrappedValue.dismiss()
                    }
                    Button("Discard creation", role: .destructive) {
                        // Discard logic here
                        
                        session.pieces = []
                        presentationMode.wrappedValue.dismiss()
                    }
                    Button("Cancel", role: .cancel) { }
                } message: {
                    Text("Focus is finishing one thing at a time.")
                }
            }
        }


#Preview {
    MainTabView()
}
