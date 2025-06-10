// Created by Arjun Agarwal

import SwiftUI
import WebKit
import AVKit
import UniformTypeIdentifiers

// MARK: - InstructionsView with GIF/Video picker & preview
struct InstructionsView: View {
    @State private var selectedData: Data? = nil
    @State private var selectedURL: URL? = nil
    @State private var showPicker = false
    @State private var currentPage = 0

    let pages = [
        OnboardingPage(title: "Create", description: "Drag and connect pieces to form your shape. Bin what’s unnecessary: focus is choosing what matters."),
        OnboardingPage(title: "Discover", description: "Let the app recognise your masterpiece. See what it says about your focus today."),
        OnboardingPage(title: "Reflect", description: "Choose to type or voice-record your thoughts and insights. Your reflections are yours to revisit anytime."),
        OnboardingPage(title: "Progress", description: "See your focus strengthen and your creativity bloom – because amazing things happen when you focus."),
        OnboardingPage(title: "Explore", description: "See your focus strengthen and your creativity bloom – because amazing things happen when you focus.")
    ]

    var body: some View {
        TabView(selection: $currentPage) {
            ForEach(pages.indices, id: \.self) { index in
                VStack(spacing: 20) {
                    // Title and description
                    Text(pages[index].title).font(.largeTitle).bold()
                    Text(pages[index].description)
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)

                    // Media area with tap to pick
                    MediaView(selectedData: selectedData, selectedURL: selectedURL)
                        .onTapGesture { showPicker = true }

                    // Page indicator dots
                    HStack(spacing: 8) {
                        ForEach(pages.indices, id: \.self) { dotIndex in
                            Circle()
                                .fill(dotIndex == currentPage ? .black : .gray.opacity(0.4))
                                .frame(width: 8, height: 8)
                        }
                    }
                    .padding(.top, 8)
                }
                    .padding().tag(index)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.bottom, 120)
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .sheet(isPresented: $showPicker) {
            FilePicker(selectedData: $selectedData, selectedURL: $selectedURL)
        }
    }
}

// MARK: - Data model for onboarding pages
struct OnboardingPage: Identifiable {
    let id = UUID()
    let title: String
    let description: String
}

// MARK: - MediaView: Displays GIF, video, or placeholder
struct MediaView: View {
    let selectedData: Data?
    let selectedURL: URL?

    var body: some View {
        ZStack {
            if let data = selectedData, data.isGIF {
                GIFView(data: data)
            } else if let url = selectedURL {
                LoopingVideoPlayer(url: url)
            } else if let assetData = NSDataAsset(name: "gifVideo")?.data {
                GIFView(data: assetData)
            } else {
                PlaceholderBox()
            }
        }
        .frame(height: 250)
        .cornerRadius(16)
    }
}

// MARK: - GIFView: Renders GIF using WKWebView
struct GIFView: UIViewRepresentable {
    let data: Data

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.scrollView.isScrollEnabled = false
        webView.isUserInteractionEnabled = false
        webView.backgroundColor = .clear
        webView.load(data, mimeType: "image/gif", characterEncodingName: "", baseURL: URL(string: "about:blank")!)
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}
}

// MARK: - LoopingVideoPlayer: AVPlayer that loops
struct LoopingVideoPlayer: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let player = AVQueuePlayer()
        let item = AVPlayerItem(url: url)
        context.coordinator.looper = AVPlayerLooper(player: player, templateItem: item)

        let controller = AVPlayerViewController()
        controller.player = player
        controller.showsPlaybackControls = false

        player.play()
        return controller
    }

    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator {
        var looper: AVPlayerLooper?
    }
}

// MARK: - FilePicker: Picks GIF or Video from Files app
struct FilePicker: UIViewControllerRepresentable {
    @Binding var selectedData: Data?
    @Binding var selectedURL: URL?

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.gif, .mpeg4Movie, .quickTimeMovie], asCopy: true)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}

    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var parent: FilePicker

        init(_ parent: FilePicker) {
            self.parent = parent
        }

        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let url = urls.first else { return }

            switch url.pathExtension.lowercased() {
            case "gif":
                parent.selectedData = try? Data(contentsOf: url)
                parent.selectedURL = nil
            default:
                parent.selectedURL = url
                parent.selectedData = nil
            }
        }
    }
}

// MARK: - Placeholder UI box for missing media
struct PlaceholderBox: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(Color.gray.opacity(0.3))
            .frame(height: 250)
            .overlay(Text("+").foregroundColor(.gray))
    }
}

// MARK: - Utility to detect GIF Data
extension Data {
    var isGIF: Bool {
        let gifHeader: [UInt8] = [0x47, 0x49, 0x46] // "GIF"
        return self.prefix(3).elementsEqual(gifHeader)
    }
}
