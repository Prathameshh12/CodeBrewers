
import SwiftUI

struct ExpandReflectionView: View {
    
    let item: FavoriteItem
    @State private var isVisibleInExplore = true
    
    var body: some View {
        ZStack {
            ZStack(alignment: .leading) {
                Image("Spotlight")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
            }
// MARK: - Main Part
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
                            Toggle("", isOn: $isVisibleInExplore)
                                .labelsHidden()
                            Text("Visible in Explore")
                                .font(.body)
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 20)
                        .padding(.bottom, 20)
                
                        .frame(maxWidth: .infinity, alignment: .center)
                        HStack{
                            Text("Your reflection")
                                .font(.title)
                                .fontWeight(.bold)
                                .padding(.horizontal)
                            Spacer()
                        }
                        Text(item.reflect)
                            .padding(.horizontal)
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
