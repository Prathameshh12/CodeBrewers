
import SwiftUI

struct ExploreView: View{
    @State private var showSidebar = false
    var body: some View {
        ZStack(alignment: .leading) {
            ZStack(){
                NavigationStack(){
                VStack(alignment: .leading){
                    // Top bar
                    HStack {
                        Button(action: {
                            withAnimation {
                                showSidebar.toggle()
                            }
                        }){
                            Image("logo")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 30, height: 30)
                                .clipShape(Rectangle())
                                .padding(.leading, 0)
                        }
                        Text("Explore")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.leading, 8)
                        
                        Spacer()
                        
                    }
                    Spacer()
                    
                }
            }
        }
            .padding()
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

