import SwiftUI

class PuzzleSession: ObservableObject {
    @Published var pieces: [PuzzlePiece] = []
    @Published var selectedColor: Color = .black
}

enum Tab {
    case reflections, create, explore
}

struct MainTabView: View {
    @State private var selectedTab: Tab = .create
    @State private var createGoToPuzzle: (() -> Void)? = nil
    @State private var path: [String] = []
    @StateObject private var session = PuzzleSession()


    var body: some View {
        
        NavigationStack(path: $path) {
            ZStack(alignment: .bottom) {
                switch selectedTab {
                case .reflections:
                    ReflectionsView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color(.systemGray6).ignoresSafeArea())
                        .padding(.bottom, -94)
                case .create:
                    ContentView(
                        setGoToPuzzle: { closure in self.createGoToPuzzle = closure }, path: $path
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(.systemGray6).ignoresSafeArea())
                    .padding(.bottom, -94)
                case .explore:
                    ExploreView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color(.systemGray6).ignoresSafeArea())
                        .padding(.bottom, -94)
                }
                CustomTabBar(
                    selectedTab: $selectedTab,
                    onCreateAgain: {
                        if selectedTab == .create {
                            createGoToPuzzle?()
                        } else {
                            selectedTab = .create
                        }
                    }
                )
                .edgesIgnoringSafeArea(.bottom)
            }
            .navigationDestination(for: String.self) { value in
                switch value {
                case "puzzle":
                    PuzzleView(path: $path)
                case "colour":
                    ColourPuzzleView(path: $path)
                case "analysing":
                    AnalysingAnimation(path: $path)
                case "analysis":
                    AnalysisView(path: $path)
                case "write":
                    WriteReflectionView(path: $path, selectedTab: $selectedTab)
                default:
                    ContentView(
                        setGoToPuzzle: { closure in self.createGoToPuzzle = closure }, path: $path
                    )
                }
            }
        }
        .environmentObject(session)
    }
}

//
//import SwiftUI
//
//enum Tab {
//    case reflections, create, explore
//}
//
//struct MainTabView: View {
//    @State private var selectedTab: Tab = .create
//    @State private var showPuzzle = false
//    @State private var createGoToPuzzle: (() -> Void)? = nil
//    @State private var path: [String] = []
//    
//    var body: some View {
//        
//        NavigationStack {
//            ZStack(alignment: .bottom) {
//                Group {
//                    switch selectedTab {
//                    case .reflections:
//                        ReflectionsView()
//                    case .create:
//                        ContentView(setGoToPuzzle: { closure in self.createGoToPuzzle = closure }, showPuzzle: $showPuzzle)
//                    case .explore:
//                        ExploreView()
//                    }
//                }
//                .frame(maxWidth: .infinity, maxHeight: .infinity)
//                .background(Color(.systemGray6).ignoresSafeArea())
//                .padding(.bottom, -94)
//                
//                CustomTabBar(
//                    selectedTab: $selectedTab,
//                    onCreateAgain: {
//                        if selectedTab == .create {
//                            createGoToPuzzle?()
//                        } else {
//                            selectedTab = .create
//                        }
//                    }
//                )
//                .edgesIgnoringSafeArea(.bottom)
//            }
//            .navigationDestination(isPresented: $showPuzzle) {
//                PuzzleView()
//            }
//        }
//    }
//}
//    
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
