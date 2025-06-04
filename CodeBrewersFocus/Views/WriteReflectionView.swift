
import SwiftUI

struct WriteReflectionView: View{
    @State private var reflectionText = ""
    @State private var showConfirmation = false
    @FocusState private var isTextEditorFocused: Bool
    
    var body: some View {
        
        VStack(alignment: .leading) {
            

            // Title with icon
            HStack(alignment: .top, spacing: 8) {
                Image(systemName: "bubbles.and.sparkles.fill")
                    .font(.largeTitle)
                Text("Tree and focus")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    }
            .padding(.horizontal)
            .padding(.top, 2)
            
            // Reflection input
            ZStack(alignment: .topLeading){
                TextEditor(text: $reflectionText)
                    .frame(minHeight: 150)
                    .padding(.horizontal)
                    .padding(.top, 0)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.clear, lineWidth: 1)
                            )
                    .focused($isTextEditorFocused)

                
                if reflectionText.isEmpty {
                    Text("Reflect on the relationship between your creation and focus")
                        .foregroundColor(.gray)
                        .padding(.horizontal, 20)
                        .padding(.top, 2)
                        .onTapGesture {
                            isTextEditorFocused = true
                                    }
                        }
                    }
            .contentShape(Rectangle())
            .onTapGesture {
                isTextEditorFocused = true
            }
            
            // Save Button
            Button(action: {
                isTextEditorFocused = false
                withAnimation {
                    showConfirmation = true
                }
            }) {
                Text("Save")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(reflectionText.isEmpty ? Color.gray.opacity(0.2) : Color.blue)
                    .foregroundColor(reflectionText.isEmpty ? .gray : .white)
                    .cornerRadius(25)
            }
            .padding(.horizontal)
            .padding(.top, 10)
            .disabled(reflectionText.isEmpty)        }
        .padding()
        .overlay(
            Group {
                if showConfirmation {
                    VStack(spacing: 0) {
                        VStack(spacing: 12) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 30))
                                .foregroundColor(.blue)

                            Text("Reflection saved")
                                .font(.headline)
                                .bold()

                            Text("Your reflections\nare yours to revisit anytime.")
                                .font(.subheadline)
                                .multilineTextAlignment(.center)
                        }
                        .padding()

                        Divider()

                        Button(action: {
                            withAnimation {
                                showConfirmation = false
                            }
                        }) {
                            Text("Cool!")
                                .font(.body)
                                .fontWeight(.semibold)
                                .foregroundColor(.blue)
                                .frame(maxWidth: .infinity)
                                .padding(12)
                        }
                    }
                    .background(Color.white)
                    .cornerRadius(16)
                    .padding(.horizontal, 40)
                    .shadow(radius: 10)
                    .transition(.scale)
                }
            }
        )
        .navigationTitle("Reflection")
        .navigationBarTitleDisplayMode(.inline)

    }
}

#Preview {
    MainTabView()
}
