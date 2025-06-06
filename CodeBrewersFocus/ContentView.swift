
import SwiftUI

// I did something

struct ContentView: View {
    
    var setGoToPuzzle: ((@escaping () -> Void) -> Void)? = nil
    @Binding var path: [String]
    
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
                        Image("LogoBlock")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 30, height: 30)
                    }
                    Spacer()
                }
                .padding(.top)
                .padding(.horizontal)
// MARK: - Main Part
                VStack {
                    Spacer()
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
                        .padding(.top, 2)
                    Spacer()
                }
                .padding(.bottom, 180)
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
            setGoToPuzzle?({
                path.append("puzzle")
            })
        }
    }
}

#Preview {
    MainTabView()
}
