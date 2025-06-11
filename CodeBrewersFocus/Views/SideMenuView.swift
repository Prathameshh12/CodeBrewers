//  Created by Arjun Agarwal

import SwiftUI

struct SideMenuView: View {
    
    var body: some View {
        VStack {
            
            HStack (alignment: .center, spacing: 2){
                Image("LogoBlock")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 30, height: 30)
                Text("singular")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.horizontal, 6)
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top)
            .padding(.bottom, 30)
            
            // Menu Items
            VStack (alignment: .leading, spacing: 24) {
                NavigationLink(destination: ProgressView()) {
                    HStack {
                        Image(systemName: "brain.fill")
                            .foregroundColor(.blue)
                            .font(.system(size: 23))
                        Text("My Progress")
                            .font(.system(size: 18))
                            .opacity(0.8)
                    }
                }
                .buttonStyle(PlainButtonStyle())
                
                NavigationLink(destination: InstructionView()) {
                    HStack {
                        Image(systemName: "info.circle.fill")
                            .foregroundStyle(.blue)
                            .font(.system(size: 23))
                            .padding(.horizontal, 2)
                        Text ("Instructions")
                            .font(.system(size: 18))
                            .opacity(0.8)
                            .padding(.horizontal, 4)
                    }
                }
                .buttonStyle(PlainButtonStyle())
                
                NavigationLink(destination: AccountView()) {
                    HStack {
                        Image(systemName: "person.fill")
                            .foregroundStyle(.blue)
                            .font(.system(size: 23))
                            .padding(.horizontal, 4)
                        Text ("Account and Settings")
                            .font(.system(size: 18))
                            .opacity(0.8)
                            .padding(.horizontal, 2)
                    }
                }
                .buttonStyle(PlainButtonStyle())
                
                NavigationLink(destination: SubscribtionView()) {
                    HStack{
                        Image(systemName: "creditcard.fill")
                            .foregroundColor(.blue)
                            .font(.system(size: 23))
                        Text ("Manage Subscription")
                            .font(.system(size: 18))
                            .opacity(0.8)
                            .padding(.horizontal, 2)
                    }
                }
                .buttonStyle(PlainButtonStyle())

                Spacer()

            }
            .padding(.leading, -32)
        }
        .frame(width: 280, alignment: .leading)
        .background(Color(.systemGray6))
        .shadow(radius: 12)
        .offset(x: -60)
    }
}

#Preview {
    SideMenuView()
}
