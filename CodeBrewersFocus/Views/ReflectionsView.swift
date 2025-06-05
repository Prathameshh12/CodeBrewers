//
//  ContentView.swift
//  reflectionsPage
//
//  Created by Megha Elisa George on 30/5/2025.
//
import SwiftUI

struct ReflectionsView: View{
    @State private var showSidebar = false
    @State private var reflectionText = ""
    @State private var showConfirmation = false
    @FocusState private var isTextEditorFocused: Bool
    
    var body: some View {
        ZStack(alignment: .leading) {
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
                        Text("Reflections")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.leading, 8)
                        Spacer()
                    }
                    .padding(.top)
                    .padding(.horizontal)
                    
                    
                }
                NavigationLink(destination: ExpandReflectionView()) {
                    Text("Wave Reflection")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
            
            .padding(.horizontal)
            .padding(.bottom, 50)
                
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
    }
}
#Preview {
    MainTabView()
}
