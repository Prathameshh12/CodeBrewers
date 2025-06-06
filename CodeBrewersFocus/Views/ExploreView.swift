
import SwiftUI

struct ExploreItem: Identifiable {
    let id = UUID()
    let imageName: String
    let tag1: String
    let tag2: String
    let tag3: String
}

struct GridItemModel: Identifiable {
    
    let id = UUID()
    let imageName: String
    let height: CGFloat
}

struct CustomSearchBar: View {
    @Binding var text: String

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)

            TextField("Search", text: $text)
                .font(.body)
                .foregroundColor(.primary)
                .disableAutocorrection(true)

            if !text.isEmpty {
                Button(action: {
                    text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(10)
        .background(Color(.white))
        .cornerRadius(20)
        .padding(.horizontal)
    }
}

struct ExploreView: View {
    @State private var showSidebar = false
    @State private var searchText = ""
    @State private var selectedCategory: String = "All"
    @State private var items: [GridItemModel] = []
    
    // Sample explore items
    private let exploreItemsBase: [ExploreItem] = [
        ExploreItem(imageName: "Tree", tag1: "Resilience", tag2: "Growth", tag3: "Nature"),
        ExploreItem(imageName: "Icecream", tag1: "Joy", tag2: "Indulgence", tag3: "Sweetness"),
        ExploreItem(imageName: "Heart", tag1: "Love", tag2: "Balance", tag3: "Steadiness"),
        ExploreItem(imageName: "Frog", tag1: "Jump", tag2: "Change", tag3: "Adaptability"),
        ExploreItem(imageName: "Happy", tag1: "Positivity", tag2: "Clarity", tag3: "Calm"),
        ExploreItem(imageName: "Strawberry", tag1: "Energy", tag2: "Nature", tag3: "Nourishment"),
        ExploreItem(imageName: "Cello", tag1: "Flow", tag2: "Melody", tag3: "Joy"),
        ExploreItem(imageName: "Castle", tag1: "Steadiness", tag2: "Travel", tag3: "Joy"),
        ExploreItem(imageName: "House", tag1: "Steadiness", tag2: "Safe", tag3: "Cozy"),
        ExploreItem(imageName: "Kite", tag1: "Fly", tag2: "Joy", tag3: "Calm")
        
        
    ]
    private let categories = ["All", "Joy", "Nature", "Growth", "Energy", "Balance", "Love"]
    
    func splitToMasonryColumns(items: [ExploreItem]) -> ([ExploreItem], [ExploreItem]) {
            var left: [ExploreItem] = []
            var right: [ExploreItem] = []
            for (index, item) in items.enumerated() {
                if index % 2 == 0 {
                    left.append(item)
                } else {
                    right.append(item)
                }
            }
            return (left, right)
        }
        func masonryColumn(_ items: [ExploreItem], itemWidth: CGFloat) -> some View {
            VStack(spacing: 10) {
                ForEach(items) { item in
                    NavigationLink(destination: ExpandExploreView(item: item)) {
                        Image(item.imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: itemWidth)
                            .background(Color.white)
                            .cornerRadius(16)
                    }
                }
            }
        }
    
    var filteredItems: [ExploreItem] {
        exploreItemsBase.filter {
            (searchText.isEmpty ||
             $0.tag1.localizedCaseInsensitiveContains(searchText) ||
             $0.tag2.localizedCaseInsensitiveContains(searchText) ||
             $0.tag3.localizedCaseInsensitiveContains(searchText))
            &&
            (selectedCategory == "All" || [$0.tag1, $0.tag2, $0.tag3].contains(selectedCategory))
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .leading) {
                VStack(alignment: .leading, spacing: 0) {
                    // MARK: -  Top Bar
                    HStack {
                        Button(action: {
                            withAnimation { showSidebar.toggle() }
                        }) {
                            Image("LogoBlock")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 30, height: 30)
                        }
                        Text("Explore")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.leading, 8)
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    // MARK: -  Search bar
                    CustomSearchBar(text: $searchText)
                        .padding(.top, 20)
                    // MARK: - Category Scroll
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 6) {
                            ForEach(categories, id: \.self) { category in
                                Button(action: {
                                    selectedCategory = category
                                }) {
                                    Text(category)
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 4)
                                        .background(selectedCategory == category ? Color.black : Color.white.opacity(0.9))
                                        .foregroundColor(selectedCategory == category ? .white : .black)
                                        .clipShape(Capsule())
                                        .overlay(
                                            Capsule()
                                                .stroke(Color.clear, lineWidth: 1)
                                        )
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                        .padding(.top, 12)
                    .padding(.bottom, 4)
                    // MARK: - Grid
                    ScrollView {
                        let screenWidth = UIScreen.main.bounds.width
                        let gridPadding: CGFloat = 20
                        let itemSpacing: CGFloat = 10
                        let itemWidth = (screenWidth - gridPadding * 2 - itemSpacing) / 2

                        let items = filteredItems.shuffled()
                        let (left, right) = splitToMasonryColumns(items: items)
                        
                        HStack(alignment: .top, spacing: itemSpacing) {
                            masonryColumn(left, itemWidth: itemWidth)
                            masonryColumn(right, itemWidth: itemWidth)
                        }
                        .padding(.horizontal, gridPadding)
                        .padding(.top, 8)
                    }
                    .padding(.bottom, 160)
                    // MARK: - Side Menu
                    if showSidebar {
                        Color.black.opacity(0.3)
                            .ignoresSafeArea()
                            .onTapGesture { withAnimation { showSidebar = false } }
                        
                        SideMenuView()
                            .frame(width: 300)
                            .transition(.move(edge: .leading))
                            .offset(x: showSidebar ? 0 : -300)
                            .animation(.easeInOut, value: showSidebar)
                    }
                }
            }
        }
    }
}

        #Preview {
            MainTabView()
        }
