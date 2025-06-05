

import Foundation

class PuzzleDraftManager {
    static let shared = PuzzleDraftManager()
    private let draftKey = "savedPuzzleDraft"

    func saveDraft(_ pieces: [PuzzlePiece]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(pieces) {
            UserDefaults.standard.set(encoded, forKey: draftKey)
        }
    }

    func loadDraft() -> [PuzzlePiece]? {
        guard let savedData = UserDefaults.standard.data(forKey: draftKey) else { return nil }
        let decoder = JSONDecoder()
        if let decoded = try? decoder.decode([PuzzlePiece].self, from: savedData) {
            return decoded
        }
        return nil
    }

    func clearDraft() {
        UserDefaults.standard.removeObject(forKey: draftKey)
    }

    func draftExists() -> Bool {
        return UserDefaults.standard.data(forKey: draftKey) != nil
    }
}
