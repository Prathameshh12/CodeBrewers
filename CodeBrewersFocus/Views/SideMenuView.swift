

import SwiftUI

struct SideMenuView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            HStack(){
            Image("logo")
                .resizable()
                .scaledToFill()
                .frame(width: 30, height: 30)
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
                    .foregroundColor(.gray)
                
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
