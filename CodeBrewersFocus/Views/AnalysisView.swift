
import SwiftUI

struct AnalysisView: View {
    @Binding var path: [String]
    @State private var isVisibleInExplore = true
    
    var body: some View {

        VStack{
            Text("It's a Tree!")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("A symbol of resilience and growth.")
                .font(.title3)
                .padding(.bottom, 30)
            
            ColourPuzzleSnapshot()
                .frame(width: 400, height: 400)
            
            HStack {
                Toggle("", isOn: $isVisibleInExplore)
                    .labelsHidden()
                Text("Make the creation visible in Explore")
                    .font(.body)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.top, 60)
            .padding(.bottom, 50)
            
            Button(action: {
                if path.last != "write" {
                    path.append("write")
                }
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "bubbles.and.sparkles.fill")
                    Text("Reflect")
                        .fontWeight(.bold)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, minHeight: 52)
                .background(Color.blue)
                .clipShape(Capsule())
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
        }
    }
}

#Preview {
    MainTabView()
}
