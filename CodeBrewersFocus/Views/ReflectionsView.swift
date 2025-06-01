
import SwiftUI

struct ReflectionsView: View{
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
                    
                    
                    
                    Text("Reflections")
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
