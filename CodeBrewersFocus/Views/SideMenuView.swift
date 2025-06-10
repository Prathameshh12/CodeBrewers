// Created by Arjun Agarwal

import SwiftUI

// Side menu view containing a fixed logo, static username, and navigation menu items
struct SideMenuView: View {
    // Static username displayed below the logo
    @State private var username: String = "Singular"

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            // MARK: - Profile Section
            HStack(spacing: 12) {
                // Fixed app logo image
                Image("LogoBlock")
                    .resizable()
                    .frame(width: 40, height: 40)

                // Static username display
                Text("Singualar")
                    .font(.title3)
                    .fontWeight(.semibold)
            }
            .padding(.top, 40)
            .padding(.bottom, 8)
            .padding(.leading, 12)
            .frame(maxWidth: .infinity, alignment: .leading)

            // MARK: - Menu Items
            // List of navigation options using reusable MenuItem components
            MenuItem(icon: "brain.fill", label: "My progress")
            MenuItem(icon: "info.circle.fill", label: "Instructions")
            MenuItem(icon: "person.fill", label: "Account")
            MenuItem(icon: "creditcard.fill", label: "Manage subscription")

            Spacer() // Push remaining content to top
        }
        .padding(.top, 24)
        .frame(maxWidth: .infinity)
        .background(Color(.systemBackground)) // Adaptive background for light/dark mode
        .edgesIgnoringSafeArea(.vertical)
    }
}

// Preview for development in Xcode canvas
#Preview {
    MainTabView()
}
