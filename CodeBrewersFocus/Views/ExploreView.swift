
import SwiftUI

struct GridItemModel: Identifiable {
    let id = UUID()
    let imageName: String
    let height: CGFloat
}

struct ExploreView: View {
    @State private var showSidebar = false
    
    // Random height grid items
    let items: [GridItemModel] = (1...20).map {
        GridItemModel(
            imageName: "placeholder\($0 % 5)",//change
            height: CGFloat.random(in: 120...240)
        )
    }
    
    let columnsCount = 2
    @State private var searchText = ""

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
            .background(Color(.systemGray5))
            .cornerRadius(20)
            .padding(.horizontal)
        }
    }
    var body: some View {
        GeometryReader { geometry in
            let spacing: CGFloat = 10
            let totalSpacing = spacing * CGFloat(columnsCount - 1)
            let itemWidth = (geometry.size.width - totalSpacing - 35) / CGFloat(columnsCount)
            VStack(alignment: .leading) {
// MARK: -  Header
                HStack {
                    Button(action: {
                        withAnimation {
                            showSidebar.toggle()
                        }
                    }) {
                        Image("Puppy")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
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
// MARK: -  Category buttons
                HStack {
                    ForEach(["Flow", "Adaptability", "Presence"], id: \.self) { title in
                        Button(title) {}
                            .foregroundStyle(Color.black)
                            .padding(10)
                            .background(Color(.systemGray5))
                            .cornerRadius(20)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                // Grid
                ScrollView {
                    LazyVGrid(
                        columns: Array(repeating: GridItem(.fixed(itemWidth), spacing: spacing), count: columnsCount),
                        spacing: spacing
                    ) {
                        ForEach(items) { item in
                            ZStack {
                                Color.gray.opacity(0.2)
                                Text(item.imageName) // Placeholder text — replace with Image if needed
                            }
                            .frame(width: itemWidth, height: item.height)
                            .cornerRadius(8)
                        }
                    }
                    .padding()
                }
                Spacer()
            }
        }
//        .searchable(text: $searchText, prompt: "Search images")
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

#Preview {
    ExploreView()
}
