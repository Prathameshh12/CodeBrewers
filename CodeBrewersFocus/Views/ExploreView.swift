
import SwiftUI

struct ExploreView: View{
    @State private var showSidebar = false
    var body: some View {
        ZStack(alignment: .leading) {
            ZStack(){
                NavigationStack(){
                VStack(alignment: .leading){
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
                        Text("Explore")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.leading, 8)
                        Spacer()
                    }
                    .padding(.top)
                    .padding(.horizontal)
                    
                }
            }
        }
            .padding()
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
            
        }
        
        
    }
#Preview {
    MainTabView()
}

