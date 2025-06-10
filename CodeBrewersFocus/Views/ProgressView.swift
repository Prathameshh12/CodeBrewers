
import SwiftUI

struct ProgressView: View {
    var body: some View {
            
            VStack {
                HStack {
                    Text("One Focus, Better Result")
                        .foregroundColor(.black)
                        . opacity(0.6)
                        .font(.body)
                        .padding(.horizontal)
                        .padding(.top, 10)
                }
                
                HStack(alignment: .center) {
                    VStack(alignment: .leading, spacing: 10) {
                        Image(systemName: "cup.and.heat.waves.fill")
                            .font(.system(size: 25))
                            .foregroundColor(.blue)
                        
                        Text("This week, you switched apps less while focusing.")
                            .foregroundColor(.black)
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text("It’s all about paying attention to one thing at a time.")
                            .foregroundColor(.gray)
                            .font(.body)
                    }
                    .padding(.leading, 16)
                    .padding(.vertical, 32)
                    
                    Spacer()
                    
                    ZStack (alignment: .center) {
                        Image("switching-apps")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 130)
                       
                        Text("-19%")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                    }
                    .padding(.trailing, 16)
                }
                .background(Color.white)
                .cornerRadius(20) // se quiser o efeito de bordas arredondadas como no print
                .padding(.horizontal)
                
// Unique creations
                HStack {
                    Text("Focus sparks creativity")
                        .foregroundColor(.black)
                        . opacity(0.6)
                        .font(.body)
                        .padding(.horizontal)
                        .padding(.top, 10)
                }
                
                HStack(alignment: .center) {
                    VStack(alignment: .leading, spacing: 10) {
                        Image(systemName: "cloud.rainbow.crop.fill")
                            .font(.system(size: 25))
                            .foregroundColor(.blue)
                        
                        Text("Overall, 40% of your creations are unique!")
                            .foregroundColor(.black)
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text("You are getting more creative everyday.")
                            .foregroundColor(.gray)
                            .font(.body)
                    }
                    .padding(.leading, 16)
                    .padding(.vertical, 32)
                    
                    Spacer()
                
                    Image("creative-image")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 130)
                       
                    .padding(.trailing, 16)
                }
                .background(Color.white)
                .cornerRadius(20)
                .padding(.horizontal)
                
                
             Spacer()
            }
            .background(Color(.systemGray6))
            .navigationBarBackButtonHidden(false)
            .navigationTitle("Progress")
            .navigationBarTitleDisplayMode(.inline)
            
        }
    }


#Preview {
    ProgressView()
}
