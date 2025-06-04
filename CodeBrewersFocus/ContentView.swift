

import SwiftUI

struct ContentView: View {
    @State private var showSidebar = false
    var body: some View {
        ZStack(alignment: .leading) {
            ZStack {
                NavigationStack(){
                    VStack(alignment: .leading){
                        HStack(){
                            Button(action: {
                                withAnimation {
                                    showSidebar.toggle()
                                }
                            }){
                                Image("wave")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 40, height: 40)
                                    .clipShape(Circle())
                                    .padding(.leading, 0)
                            }
                            
                            
                            Text("Mr.Puppy")
                                .font(.title)
                                .fontWeight(.bold)
                                .padding(.leading, 8)
                            
                            Spacer()
                        }
                        Spacer()
                    }
                    
                    
                }
                
                VStack {
                    Spacer()
                    
                    VStack(spacing: 8) {
                        Text("Let's step into a\n mindful digital space")
                            .font(.title)
                            .fontWeight(.semibold)
                            .multilineTextAlignment(.center)
                        
                        Text("Amazing things happen when you focus")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    NavigationLink(destination: PuzzleView()) {
                        ZStack {
                            Circle()
                                .fill(Color.blue)
                                .frame(width: 70, height: 70)
                            Image(systemName: "plus.app.fill")
                                .foregroundColor(.white)
                                .font(.system(size: 30, weight: .bold))
                        }
                    }
                }
                .padding(.bottom, 24)
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

