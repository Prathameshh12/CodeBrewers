//
//  ContentView.swift
//  reflectionsPage
//
//  Created by Megha Elisa George on 30/5/2025.
//
import SwiftUI

struct FavoriteItem: Identifiable {
    let id = UUID()
    let imageName: String
    let name: String
    let desc: String
    let date: Date
}
struct ReflectionsView: View {
    @State private var items: [FavoriteItem] = [
        FavoriteItem(imageName: "tree", name: "Tree", desc: "Resilience & Growth", date: Date()),
        FavoriteItem(imageName: "icecream",name: "Ice Cream", desc: "Living Moments & Letting Go", date: Date()),
        FavoriteItem(imageName: "heart", name: "Heart", desc: "Centeredness & Steadiness", date: Date()),
        FavoriteItem(imageName: "frog", name: "Frog", desc: "Leap & Change",date: Date()),
        FavoriteItem(imageName: "happy", name: "Happy Face", desc: "Calm & Positivity",date: Date()),
        FavoriteItem(imageName: "strawberry", name: "Strawberyy", desc: "Nourishment & Vitality",date: Date())
    ]
    var body: some View {
        NavigationView {
            Form{
                    ForEach($items) { $item in
                        HStack(spacing : 10){
                            Image(item.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 70, height: 70)
                            VStack (alignment: .leading){
                                Spacer()
                                Text(item.name)
                                Text(item.desc)
                                    .foregroundColor(.gray)
                                Text(item.date, style: .date)
                                    .foregroundColor(.gray)
                                    .font(.footnote)
                                Spacer()
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .padding(.horizontal)
                                .foregroundColor(.gray)
                        }
                    }
            }
            .navigationTitle("Reflections")
        }
    }
}
#Preview {
    ReflectionsView()
}
