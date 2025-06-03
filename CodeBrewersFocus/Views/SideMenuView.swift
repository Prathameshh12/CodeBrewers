import SwiftUI

struct SideMenuView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text("👋 Hello, Mr. Puppy")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top, 80)

            Text("My progress")
            Text("Instructions")
            Text("Account")
            Text("Manage subscription")
            Text("Settings and privacy")

            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .edgesIgnoringSafeArea(.all)
    }
}
