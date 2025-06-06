
import SwiftUI

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
    
    let imageNames = [
        "Frog", "Happy", "Strawberry", "Tree", "Icecream", "Heart"
    ]
    @State private var items: [GridItemModel] = []

    let columnsCount = 2
    @State private var searchText = ""
    
    init() {
            var tempItems = imageNames.map {
                GridItemModel(
                    imageName: $0,
                    height: CGFloat.random(in: 120...240)
                )
            }
            tempItems.shuffle()
            _items = State(initialValue: tempItems)
        }
    
    private func splitItems() -> ([GridItemModel], [GridItemModel]) {
           var left: [GridItemModel] = []
           var right: [GridItemModel] = []
           var leftHeight: CGFloat = 0
           var rightHeight: CGFloat = 0
           for item in items {
               if leftHeight <= rightHeight {
                   left.append(item)
                   leftHeight += item.height
               } else {
                   right.append(item)
                   rightHeight += item.height
               }
           }
           return (left, right)
       }
    
    var body: some View {
        ZStack(alignment: .leading) {
            GeometryReader { geometry in
                let spacing: CGFloat = 10
                let totalSpacing = spacing
                let itemWidth = (geometry.size.width - totalSpacing - 40) / 2
                
                VStack(alignment: .leading) {
                    // MARK: -  Top Bar
                    HStack {
                        Button(action: {
                            withAnimation {
                                showSidebar.toggle()
                            }
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
                    .padding(.top)
                    .padding(.horizontal)
                    // MARK: -  Search bar
                    CustomSearchBar(text: $searchText)
                    // MARK: - Category buttons
                    HStack {
                        ForEach(["Flow", "Adaptability", "Presence"], id: \.self) { title in
                            Button(title) {
                            }
                            .font(.subheadline)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 4)
                            .background(Color(.white))
                            .foregroundStyle(Color.black)
                            .clipShape(Capsule())
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    // MARK: - Grid
                    ScrollView {
                        let (left, right) = splitItems()
                        HStack(alignment: .top, spacing: spacing) {
                            VStack(spacing: spacing) {
                                ForEach(left) { item in
                                    ZStack {
                                        Color.gray.opacity(0.2)
                                        Image(item.imageName)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: itemWidth, height: item.height)
                                    }
                                    .cornerRadius(8)
                                }
                            }
                            VStack(spacing: spacing) {
                                ForEach(right) { item in
                                    ZStack {
                                        Color.gray.opacity(0.2)
                                        Image(item.imageName)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: itemWidth, height: item.height)
                                    }
                                    .cornerRadius(8)
                                }
                            }
                        }
                        .padding()
                    }
                    .padding(.bottom, 160)
                }
            }
            // MARK: - Side Menu
            if showSidebar {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            showSidebar = false
                        }
                    }
                
                SideMenuView()
                    .frame(width: 300)
                    .transition(.move(edge: .leading))
                    .offset(x: showSidebar ? 0 : -260)
                    .animation(.easeInOut, value: showSidebar)
            }
        }
    }
}

#Preview {
    MainTabView()
}
