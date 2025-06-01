//
//  MainTabView.swift
//  CodeBrewersPuzzle
//
//  Created by Prathamesh Ahire on 31/5/2025.
//


import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            ReflectionsView()
                .tabItem {
                    Label("Reflections", systemImage: "square.and.pencil")
                }

            NavigationView {
                ContentView()
            }
            .tabItem {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 30))
                Text("Create")
            }

            ExploreView()
                .tabItem {
                    Label("Explore", systemImage: "globe")
                }
        }
    }
}
