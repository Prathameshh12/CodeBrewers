
import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            ReflectionsView()
                .tabItem {
                    Label("Reflections", systemImage: "bubbles.and.sparkles")
                }

            NavigationView {
                ContentView()
            }
            .tabItem {
                Image(systemName: "plus.app")
                    .font(.system(size: 30))
                Text("Create")
            }

            ExploreView()
                .tabItem {
                    Label("Explore", systemImage: "rectangle.3.group")
                }
        }
    }
}
