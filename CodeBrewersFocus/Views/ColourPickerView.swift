
import SwiftUI

struct ColourPickerView: View {
    @Binding var selectedColor: Color

    let colors: [Color] = [.black, .blue, .green, .yellow, .orange, .indigo, .purple, .teal, .red, .brown]
    
    let columns = Array(repeating: GridItem(.flexible(), spacing: 16), count: 5)

    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.gray)
                .opacity(0.1)
                .frame(width: 360, height: 130)
                .cornerRadius(14)
            LazyVGrid(columns: columns, spacing: 16) {
                       ForEach(colors, id: \.self) { color in
                           Circle()
                               .fill(color)
                               .frame(width: 30, height: 30)
                               .overlay(
                                   Circle()
                                       .stroke(selectedColor == color ? Color.gray : Color.clear, lineWidth: 2)
                               )
                               .onTapGesture {
                                   selectedColor = color
                               }
                       }
                   }
        }
        .padding()
        }
}
#Preview {
    MainTabView()
}
