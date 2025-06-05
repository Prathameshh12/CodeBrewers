

import SwiftUI

struct SideMenuView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            HStack(){
            Image("applogo")
                .resizable()
                .scaledToFill()
                .frame(width: 40, height: 40)
                .clipShape(Rectangle())
                .padding(.leading, 16)
                .padding(.top, 40)
            Text("singular")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 40)
            
        }
            NavigationLink(destination: ProgressView()) {
                Text("My Progress")
            }

            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    MainTabView()
}
