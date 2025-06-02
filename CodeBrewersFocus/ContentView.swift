

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            NavigationStack(){
                VStack(alignment: .leading){
                    HStack(){
                        Image("wave")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                            .padding(.leading, 16)
                            
                        
                        Text("Mr.Puppy")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.leading, 8)
                        Text("Mr.Puppy")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.leading, 8)
                        
                        Spacer()
                    }
                    Spacer()
                }
             
                    
                }

            VStack {
                Spacer()

                VStack(spacing: 8) {
                    Text("Let's step into a\n mindful digital space")
                        .font(.title)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)

                    Text("Amazing things happen when you focus")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }

                Spacer()

                 
                    ZStack {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 70, height: 70)
                        Image(systemName: "plus.app.fill")
                            .foregroundColor(.white)
                            .font(.system(size: 30, weight: .bold))
                    }
                }
                .padding(.bottom, 24)
            }
            .padding()
        }
    
    }

#Preview {
    MainTabView()
}

