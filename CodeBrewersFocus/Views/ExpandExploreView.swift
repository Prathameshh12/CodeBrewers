
import SwiftUI

struct ExpandExploreView: View {
    let item: ExploreItem
    @State private var isVisibleInExplore = true
    
    var body: some View {
        ZStack {
            ZStack(alignment: .leading) {
                Image("Spotlight")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .offset(x: -14)
            }
            
            
            VStack(spacing: 20) {
                Text(item.imageName)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 80)
                
                HStack {
                    ForEach([item.tag1, item.tag2, item.tag3], id: \.self) { tag in
                        Button(tag) {}
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.white.opacity(0.7))
                            .foregroundColor(.black)
                            .clipShape(Capsule())
                    }
                }
                
                ScrollView {
                    VStack(spacing: 20) {
                        Image(item.imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 300)
                            .frame(maxWidth: 200)
                        
                        
                    }
                }
                .padding(.top, 40)
            }
            .padding(.horizontal)
        }
        .navigationTitle("Creation")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    MainTabView()
}
