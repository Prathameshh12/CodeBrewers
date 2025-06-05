
import SwiftUI

struct ExpandReflectionView: View {
    
    let item: FavoriteItem
    
    var body: some View {
        ZStack {
            ZStack(alignment: .leading) {
                Image("Spotlight")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
            }
// MARK: - Top Bar
            VStack (spacing: 20){
                
                Text(item.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 80)
                
                HStack{
                    Button(item.tag1) {
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 4)
                    .background(Color.white)
                    .foregroundStyle(.black)
                    .opacity(0.7)
                    .clipShape(Capsule())
                    .overlay(
                        Capsule()
                            .stroke(Color.clear, lineWidth: 1.5)
                        )
                    Button(item.tag2) {
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Color.white)
                    .foregroundStyle(.black)
                    .opacity(0.7)
                    .clipShape(Capsule())
                    .overlay(
                        Capsule()
                            .stroke(Color.clear, lineWidth: 1.5)
                        )
                }

                
                ScrollView {
                    VStack(spacing: 10) {
                        Image (item.imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 300)
                            .frame(maxWidth: 200)
                        HStack{
                            Toggle(isOn: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Is On@*/.constant(true)/*@END_MENU_TOKEN@*/) {
                                
                            }
                            Text("Visible in Explore")
                                .font(.body)
                        }
                        .frame(maxWidth: .infinity)
                        HStack{
                            Text("Your reflection")
                                .font(.title)
                                .fontWeight(.bold)
                            Spacer()
                        }
                        Text(item.reflect)
                    }
                }
                .padding(.top, 40)
            }
            .padding(.horizontal)
                          
        }
        .navigationTitle(item.date)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    MainTabView()
}

//#Preview {
//    ExpandReflectionView(item: FavoriteItem(
//        imageName: "Tree", name: "Tree", desc: "Resilience and growth", date: "12 March 2025", tag1: "Resilience", tag2: "Growth", reflect: "I realise that focus isn’t about holding still. It’s about flowing steadily in one direction, like a wave. I want to stay in the flow and not get distracted by everything around me."
//    ))
//}
