

import SwiftUI

struct BrowseDraftsView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedDraft: PuzzleDraft?
    @State private var drafts: [PuzzleDraft] = []

    var body: some View {
        NavigationView {
            List {
                ForEach(drafts) { draft in
                    Button(action: {
                        selectedDraft = draft
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        VStack(alignment: .leading) {
                            Text(draft.title)
                                .font(.headline)
                            Text(draft.date.formatted(date: .abbreviated, time: .shortened))
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .onDelete(perform: delete)
            }
            .navigationTitle("Browse Drafts")
            .navigationBarItems(leading: Button("Close") {
                presentationMode.wrappedValue.dismiss()
            })
            .onAppear {
                drafts = PuzzleDraftManager.shared.loadDrafts()
            }
        }
    }

    func delete(at offsets: IndexSet) {
        for index in offsets {
            PuzzleDraftManager.shared.deleteDraft(drafts[index])
        }
        drafts.remove(atOffsets: offsets)
    }
}
