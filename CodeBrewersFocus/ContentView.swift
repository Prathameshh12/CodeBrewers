
import SwiftUI

struct ContentView: View {
    var setGoToPuzzle: ((@escaping () -> Void) -> Void)? = nil
    @Binding var showPuzzle: Bool
    
    @State private var showSidebar = false
    
    var body: some View {
        ZStack(alignment: .leading) {
            Image("Spotlight")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
// MARK: - Top Bar
                HStack {
                    Button(action: {
                        withAnimation {
                            showSidebar.toggle()
                        }
                    }) {
                        Image("Puppy")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                    }
                    Text("Create")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.leading, 8)
                    Spacer()
                }
                .padding(.top)
                .padding(.horizontal)
// MARK: - Main Part
                VStack (spacing: 16) {
                    Image("Logo")
                        .resizable()
                        .frame(width: 120, height: 24)
                        .opacity(0.8)
                        .padding(.top, 140)
                        .padding(.bottom, 100)
                    Text("Let's step into a")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Text("mindful digital space")
                        .font(.largeTitle)
                        .foregroundColor(.blue)
                        .fontWeight(.bold)
                        .padding(.top, -16)
                    Text("Amazing things happen when you focus")
                        .font(.body)
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            }
// MARK: - Side Menu
            if showSidebar {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            showSidebar = false
                        }
                    }
                SideMenuView()
                    .frame(width: 300)
                    .transition(.move(edge: .leading))
                    .offset(x: showSidebar ? 0 : -260)
                    .animation(.easeInOut, value: showSidebar)
            }
        }
        .onAppear {
            setGoToPuzzle?({ self.showPuzzle = true })
        }
    }
}

#Preview {
    MainTabView()
}
