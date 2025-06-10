//  Created by Arjun Agarwal

import SwiftUI
 
 struct MenuItem: View {
 var icon: String
 var label: String
 
 var body: some View {
 HStack(spacing: 16) {
 Image(systemName: icon)
 .frame(width: 20, height: 24)
 .foregroundColor(.blue)
 
 NavigationLink(destination: destinationView(for: label)) {
 Text(label)
 .foregroundColor(.primary)
 .font(.body)
 }
 .buttonStyle(PlainButtonStyle())
 }
 .padding(.horizontal)
 }
 
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
 
 
 #Preview {
 MainTabView()
 }
