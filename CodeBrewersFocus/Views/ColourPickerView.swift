

import SwiftUI

struct ColourPickerView: View {
    @Binding var selectedColor: Color

    let colors: [Color] = [.black, .blue, .green, .orange, .red, .yellow, .purple, .brown, .pink, .indigo,]

    var body: some View {
     
            HStack {
                
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
            .padding()
        }
    
}
#Preview {
    
    MainTabView()
}
