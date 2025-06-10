// Created by Arjun Agarwal

import SwiftUI
import PhotosUI
import UIKit

struct SideMenuView: View {
    @State private var selectedImage: UIImage? = nil
    @State private var username: String = "Singular"

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Profile Section
            HStack(spacing: 12) {
                ZStack {
                    if let image = selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                    } else {
                        Image("LogoBlock")
                            .resizable()
                    }
                }
                .frame(width: 40, height: 40)

                Text(username)
                    .font(.title3)
                    .fontWeight(.semibold)
            }
            .padding(.top, 40)
            .padding(.bottom, 8)
            .padding(.leading, 12)
            .frame(maxWidth: .infinity, alignment: .leading)

            // Menu Items
            MenuItem(icon: "brain.fill", label: "My progress")
            MenuItem(icon: "info.circle.fill", label: "Instructions")
            MenuItem(icon: "person.fill", label: "Account")
            MenuItem(icon: "creditcard.fill", label: "Manage subscription")

            Spacer()
        }
        .padding(.top, 24)
        .frame(maxWidth: .infinity)
        .background(Color(.systemBackground)) // Background
        .edgesIgnoringSafeArea(.vertical)
    }
}

#Preview {
    MainTabView()
}
