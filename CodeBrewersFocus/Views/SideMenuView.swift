

import SwiftUI

struct SideMenuView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            HStack(){
            Image("wave")
                .resizable()
                .scaledToFill()
                .frame(width: 40, height: 40)
                .clipShape(Circle())
                .padding(.leading, 16)
                .padding(.top, 40)
            Text("Mr. Puppy")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top, 40)
            
        }
            NavigationLink(destination: PuzzleView()) {
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
