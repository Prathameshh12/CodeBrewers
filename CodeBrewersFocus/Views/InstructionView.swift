
import SwiftUI
import WebKit

struct GIFView: UIViewRepresentable {
    let data: Data

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.scrollView.isScrollEnabled = false
        webView.isUserInteractionEnabled = false
        webView.backgroundColor = .clear
        
        let base64 = data.base64EncodedString()
                let htmlString = """
                <html>
                <head>
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <style>
                        body { margin:0; background:transparent; display:flex; align-items:center; justify-content:center; height:100vh;}
                        img { max-width:100%; max-height:100%; display:block; margin:auto;}
                    </style>
                </head>
                <body>
                    <img src="data:image/gif;base64,\(base64)" />
                </body>
                </html>
                """

                webView.loadHTMLString(htmlString, baseURL: nil)

        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}
}

struct InstructionPage: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let gifAssetName: String
}

struct InstructionView: View {
    let pages = [
        InstructionPage(title: "Create", description: "Drag and connect pieces to form your shape. Bin what’s unnecessary: focus is choosing what matters.", gifAssetName: "gif1"),
        InstructionPage(title: "Discover", description: "Let the app recognise your masterpiece. See what it says about your focus today.", gifAssetName: "gif2"),
        InstructionPage(title: "Reflect", description: "Choose to type or voice-record your thoughts and insights. Your reflections are yours to revisit anytime.", gifAssetName: "gif3"),
        InstructionPage(title: "Progress", description: "See your focus strengthen and your creativity bloom – because amazing things happen when you focus.", gifAssetName: "gif4"),
        InstructionPage(title: "Explore", description: "See your focus strengthen and your creativity bloom – because amazing things happen when you focus.", gifAssetName: "gif5")
    ]

    var body: some View {
        TabView {
            ForEach(pages) { page in
                VStack(spacing: 20) {
                    Spacer()
                    
                    Text(page.title)
                        .font(.largeTitle)
                        .bold()

                    Text(page.description)
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)

                    ZStack {
                        if let assetData = NSDataAsset(name: page.gifAssetName)?.data {
                            GIFView(data: assetData)
                        }
                    }
                    .frame(height: 250)
                    .cornerRadius(16)
                    
                    Spacer()
                }
                .padding()
                .padding(.bottom, 60)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
        .background(Color(.systemGray6))
    }
}


#Preview {
    InstructionView()
}
