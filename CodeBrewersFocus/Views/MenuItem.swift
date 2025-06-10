//  Created by Arjun Agarwal

import SwiftUI

// MARK: - MenuItem: Sidebar menu row with icon and navigation
struct MenuItem: View {
    var icon: String
    var label: String

    var body: some View {
        HStack(spacing: 16) {
            // Leading icon
            Image(systemName: icon)
                .frame(width: 20, height: 24)
                .foregroundColor(.blue)

            // Destination navigation based on label
            NavigationLink(destination: destinationView(for: label)) {
                Text(label)
                    .foregroundColor(.primary)
                    .font(.body)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.horizontal)
    }

    // MARK: - Destination selector
    @ViewBuilder
    private func destinationView(for label: String) -> some View {
        switch label {
        case "My progress": ProgressView()
        case "Instructions": InstructionsView()
        case "Account": AccountView()
        case "Manage subscription": ManageSubscriptionView()
        default: Text("Page not found")
        }
    }
}

// MARK: - Preview
#Preview {
    MainTabView()
}
