import SwiftUI

struct SideMenuView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {

            HStack (alignment: .center, spacing: 12) {
                Image("LogoBlock")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .padding(.leading, 16)
                    .padding(.top)
                
                Text("Mr. Puppy")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top)
                
            }

            NavigationLink(destination: ProgressView()) {
                Text("My Progress")
                    .padding(.leading, 16)
            }
            Spacer()
        }
        .frame(width: 280, alignment: .leading)
        .background(Color.white)
        .shadow(radius: 12)
        .offset(x: -60)
//        .ignoresSafeArea(.all)
    }
}

#Preview {
    SideMenuView()
}
