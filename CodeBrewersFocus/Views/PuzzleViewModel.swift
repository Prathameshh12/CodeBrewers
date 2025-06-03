

import SwiftUI

class PuzzleViewModel: ObservableObject {
    @Published var pieces: [PuzzlePiece] = (1...30).map {
        PuzzlePiece(imageName: String(format: "Wave-%02d", $0))
    }
}
