//
//  ContentView.swift
//  reflectionsPage
//
//  Created by Megha Elisa George on 30/5/2025.
//
import SwiftUI

struct FavoriteItem: Identifiable {
    let id = UUID()
    let imageName: String
    let name: String
    let desc: String
    let date: String
    let tag1: String
    let tag2: String
    let reflect: String
}

struct ReflectionsView: View{
    @State private var showSidebar = false
    @State private var reflectionText = ""
    @State private var showConfirmation = false
    @FocusState private var isTextEditorFocused: Bool
    
    @State private var items: [FavoriteItem] = [
        FavoriteItem(imageName: "Tree", name: "Tree", desc: "Resilience and growth", date: "12 March 2025", tag1: "Resilience", tag2: "Growth", reflect: "I realise that focus isn’t about holding still. It’s about flowing steadily in one direction, like a wave. I want to stay in the flow and not get distracted by everything around me." ),
        FavoriteItem(imageName: "Icecream", name: "Ice cream", desc: "Living moments and letting go", date: "11 March 2025", tag1: "Living moments", tag2: "Letting go", reflect: "I realise that focus isn’t about holding still. It’s about flowing steadily in one direction, like a wave. I want to stay in the flow and not get distracted by everything around me."),
        FavoriteItem(imageName: "Heart", name: "Heart", desc: "Centeredness and steadiness", date: "10 March 2025", tag1: "Centeredness", tag2: "Steadiness", reflect: "I realise that focus isn’t about holding still. It’s about flowing steadily in one direction, like a wave. I want to stay in the flow and not get distracted by everything around me."),
        FavoriteItem(imageName: "Frog", name: "Frog", desc: "Leap and change", date: "9 March 2025", tag1: "Leap", tag2: "Change", reflect: "I realise that focus isn’t about holding still. It’s about flowing steadily in one direction, like a wave. I want to stay in the flow and not get distracted by everything around me."),
        FavoriteItem(imageName: "Happy", name: "Happy face", desc: "Calm and positivity", date: "8 March 2025", tag1: "Calm", tag2: "Positivity", reflect: "I realise that focus isn’t about holding still. It’s about flowing steadily in one direction, like a wave. I want to stay in the flow and not get distracted by everything around me."),
        FavoriteItem(imageName: "Strawberry", name: "Strawberry", desc: "Nourishment and vitality", date: "7 March 2025", tag1: "Nourishment", tag2: "Vitality", reflect: "I realise that focus isn’t about holding still. It’s about flowing steadily in one direction, like a wave. I want to stay in the flow and not get distracted by everything around me.")
    ]
    
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
                            Image("LogoBlock")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 30, height: 30)
                        }
                        Text("Reflections")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.leading, 8)
                        Spacer()
                    }
                    .padding(.top)
                    .padding(.horizontal)
                    // MARK: - Main Part
                    ScrollView {
                        VStack(spacing: 14) {
                            ForEach(items) { item in
                                buildCard(for: item)
                            }
                        }
                        .padding(.bottom, 20)
                    }
                    .background(Color(.systemGray6))
                    .padding(.bottom, 100)
                    
                }
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
    
    // MARK: - BuildCard
    func buildCard(for item: FavoriteItem) -> some View {
        NavigationLink(destination: ExpandReflectionView(item: item)) {
            HStack {
                Image(item.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 68, height: 68)
                    .padding(.leading, 12)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(item.name)
                        .font(.title3)
                        .foregroundColor(.black)
                    
                    Text(item.desc)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    Text(item.date)
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
                    .padding(.trailing, 16)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Color.white)
            .cornerRadius(16)
            .padding(.horizontal)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
#Preview {
    MainTabView()
}
