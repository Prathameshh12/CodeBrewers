import SwiftUI

class PuzzleSession: ObservableObject {
    @Published var pieces: [PuzzlePiece] = []
    @Published var selectedColor: Color = .clear
    @Published var onHoldShelf: [PuzzlePiece] = []
    
    @Published var isNewPuzzle: Bool = false
}



enum Tab {
    case reflections, create, explore
}

struct MainTabView: View {
    @State private var showSidebar = false
    @State private var selectedTab: Tab = .create
    @State private var createGoToPuzzle: (() -> Void)? = nil
    @State private var path: [String] = []
    @StateObject private var session = PuzzleSession()
    
    @State private var showDraftOptions = false
    @State private var showBrowseDrafts = false
    @State private var selectedDraft: PuzzleDraft?
    @State private var shouldLoadDraft = true
    @State private var showLanding = true
    
    func resetPuzzle() {
        session.pieces = (1...30).map { PuzzlePiece(imageName: String(format: "Wave-%02d", $0)) }
        session.onHoldShelf = []
        session.selectedColor = .clear
        session.isNewPuzzle = true 
    }
    
    func loadDraft(_ draft: PuzzleDraft) {
            session.pieces = draft.pieces
            session.onHoldShelf = []
            session.selectedColor = .clear
        }
    
    
    
    var body: some View {
        NavigationStack(path: $path) {
            ZStack(alignment: .bottom) {
                Group {
                    switch selectedTab {
                    case .reflections:
                        ReflectionsView(showSidebar: $showSidebar)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color(.systemGray6).ignoresSafeArea())
                            .padding(.bottom, -94)
                    case .create:
                        ContentView(
                            setGoToPuzzle: { closure in self.createGoToPuzzle = closure }, path: $path, showSidebar: $showSidebar
                        )
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color(.systemGray6).ignoresSafeArea())
                        .padding(.bottom, -94)
                    case .explore:
                        ExploreView(showSidebar: $showSidebar)
                    }
                }
                CustomTabBar(
                    selectedTab: $selectedTab,
                    onCreateAgain: {
                        if selectedTab == .create {
                            if !PuzzleDraftManager.shared.loadDrafts().isEmpty {
                                showDraftOptions = true
                            } else {
                                resetPuzzle()
                                createGoToPuzzle?()
                            }
                        } else {
                            selectedTab = .create
                        }
                    }
                )
                .edgesIgnoringSafeArea(.bottom)
                
                // popup menu
                if showDraftOptions {
                    ZStack {
                        Color.black.opacity(0.001)
                            .ignoresSafeArea()
                            .onTapGesture {
                                withAnimation(.easeOut(duration: 0.20)) {
                                    showDraftOptions = false
                                }
                            }
                        
                        // Draft options popup
                        HStack(spacing: 0) {
                            Button("Resume draft") {
                                showBrowseDrafts = true
                                showDraftOptions = false
                                
                            }
                            .padding(.vertical, 10)
                            .foregroundColor(.black)
                            
                            Divider()
                                .padding()
                            
                            Button("Start new") {
                                session.isNewPuzzle = true
                                shouldLoadDraft = false
                                resetPuzzle()
                                showDraftOptions = false
                                createGoToPuzzle?()
                            }
                            .padding(.vertical, 10)
                            .foregroundColor(.black)
                        }
                        .frame(width: 220, height: 50)
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .shadow(radius: 5)
                        .offset(y: 260)
                        .transition(.scale)
                    }
                    .zIndex(3)
                }
    
                if showSidebar {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation { showSidebar = false }
                        }
                        .zIndex(1)
                    SideMenuView()
                        .transition(.move(edge: .leading))
                        .animation(.easeInOut, value: showSidebar)
                        .zIndex(2)
                }
            }
            .navigationDestination(for: String.self) { value in
                switch value {
                case "puzzle":
                    PuzzleView(path: $path)
                        .environmentObject(session)
                case "colour":
                    ColourPuzzleView(path: $path)
                case "analysing":
                    AnalysingAnimation(path: $path)
                case "analysis":
                    AnalysisView(path: $path)
                case "write":
                    WriteReflectionView(path: $path, selectedTab: $selectedTab, onCool: {
                        resetPuzzle()
                    })
                default:
                    ContentView(
                        setGoToPuzzle: { closure in self.createGoToPuzzle = closure }, path: $path, showSidebar: $showSidebar
                    )
                }
            }
            .sheet(isPresented: $showBrowseDrafts) {
                BrowseDraftsView(selectedDraft: $selectedDraft)
            }
            .onChange(of: selectedDraft) { oldValue, newValue in
                if let draft = newValue {
                    session.pieces = draft.pieces
                    session.onHoldShelf = []
                    session.selectedColor = .clear
                    path = ["puzzle"]
                }
            }
        }
        .environmentObject(session)
        if showLanding
                {
                    LandingPageView()
                    .edgesIgnoringSafeArea(.all)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .zIndex(1)
                    .opacity(showLanding ? 1 : 0) // fade based on state
                    .animation(.easeOut(duration: 2), value: showLanding)
                    .onAppear
                    {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5)
                        {
                            showLanding = false // triggers fade out
                        }
                    }
                }
    }
}

// MARK: - Setting up custom tab bar
struct CustomTabBar: View {
    @Binding var selectedTab: Tab
        var onCreateAgain: () -> Void

    var body: some View {
        ZStack {
// MARK: - Tab bar look
            Rectangle()
                .fill(Color.white)
                .shadow(color: .black.opacity(0.2), radius: 10, y: -2)
                .frame(height: 90)
                .padding(.bottom, -70)
// MARK: -Tab bar function
            HStack {
// MARK: - Reflections
                Button {
                    selectedTab = .reflections
                } label: {
                    VStack(spacing: 2) {
                        Image(systemName: "bubbles.and.sparkles.fill")
                            .font(.system(size: 26))
                        Text("Reflections").font(.caption)
                    }
                    .foregroundColor(selectedTab == .reflections ? .blue : .gray)
                    .opacity(selectedTab == .reflections ? 1.0 : 0.5)
                }
                Spacer()
// MARK: - Create
                ZStack {
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 78, height: 78)
                        .shadow(color: .blue.opacity(0.18), radius: 8, y: 6)
                        .offset(y: -32)
                        .offset(x: -8)
                    Button {
                        onCreateAgain()
                    } label: {
                        VStack(spacing: 2) {
                            Image(systemName: "plus.app.fill")
                                .font(.system(size: 26, weight: .bold))
                            Text("Create").font(.caption).fontWeight(.bold)
                        }
                        .foregroundColor(.white)
                    }
                    .offset(y: -32)
                    .offset(x: -8)
                }
                Spacer()
// MARK: - Explore
                Button {
                    selectedTab = .explore
                } label: {
                    VStack(spacing: 2) {
                        Image(systemName: "rectangle.3.group.fill")
                            .font(.system(size: 26))
                        Text("Explore").font(.caption)
                    }
                    .foregroundColor(selectedTab == .explore ? .blue : .gray)
                    .opacity(selectedTab == .explore ? 1.0 : 0.5)
                }
            }
            .padding(.horizontal, 50)
            .padding(.bottom, -60)
        }
        .frame(height: 90)
        .edgesIgnoringSafeArea(.bottom)
    }
}

#Preview {
    MainTabView()
}
