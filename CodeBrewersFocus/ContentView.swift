
import SwiftUI

struct ContentView: View {
    
    var setGoToPuzzle: ((@escaping () -> Void) -> Void)? = nil
    @Binding var path: [String]
    
    @Binding var showSidebar: Bool
    
    var body: some View {
        ZStack {
            GeometryReader { geo in
                Image("Spotlight")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width)
                    .clipped()
                    .ignoresSafeArea()
            }
                
            
            VStack(spacing: 0) {
// MARK: - Top Bar
                HStack {
                    Button(action: {
                        withAnimation {
                            showSidebar.toggle()
                        }
                    }) {
                        Image("LogoBlock")
                            .resizable()
                            .scaledToFill()
                            .clipped()
                            .frame(width: 30, height: 30)
                    }
                    Spacer()
                }
                .padding(.top)
                .padding(.horizontal)
// MARK: - Main Part
                VStack {
                    Spacer()
                    Text("Let's step into a")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Text("mindful digital space")
                        .font(.largeTitle)
                        .foregroundColor(.blue)
                        .fontWeight(.bold)
                        .padding(.top, -16)
                    Text("Amazing things happen when you focus")
                        .font(.body)
                        .padding(.top, 2)
                    Spacer()
                }
                .padding(.bottom, 180)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            }
        }
        .onAppear {
            setGoToPuzzle?({
                path.append("puzzle")
            })
        }
    }
}

#Preview {
    MainTabView()
}
