import Foundation

struct PuzzleDraft: Identifiable, Codable, Equatable {
    let id: UUID
    var title: String
    var date: Date
    var pieces: [PuzzlePiece]

    init(title: String, pieces: [PuzzlePiece]) {
        self.id = UUID()
        self.title = title
        self.date = Date()
        self.pieces = pieces
    }
}

class PuzzleDraftManager {
    static let shared = PuzzleDraftManager()

    private let key = "puzzle_drafts"

    private init() {}

    func saveDraft(_ pieces: [PuzzlePiece], title: String = "Untitled Draft") {
        var drafts = loadDrafts()
        let newDraft = PuzzleDraft(title: title, pieces: pieces)
        drafts.append(newDraft)
        saveAllDrafts(drafts)
    }

    func loadDrafts() -> [PuzzleDraft] {
        guard let data = UserDefaults.standard.data(forKey: key),
              let drafts = try? JSONDecoder().decode([PuzzleDraft].self, from: data) else {
            return []
        }
        return drafts
    }

    func deleteDraft(_ draft: PuzzleDraft) {
        var drafts = loadDrafts()
        drafts.removeAll { $0.id == draft.id }
        saveAllDrafts(drafts)
    }

    func saveAllDrafts(_ drafts: [PuzzleDraft]) {
        if let data = try? JSONEncoder().encode(drafts) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    func clearAllDrafts() {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
