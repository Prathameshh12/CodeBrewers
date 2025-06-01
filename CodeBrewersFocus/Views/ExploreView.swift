
import SwiftUI

struct ExploreView: View{
    var body: some View {
        
        NavigationStack(){
            VStack(alignment: .leading){
                HStack(){
                    Image("wave")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                        .padding(.leading, 16)
                        
                    
                    
                    Text("Explore")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.leading, 8)
                    
                    Spacer()
                }
                Spacer()
            }
         
                
            }
        }
       
        
    }
