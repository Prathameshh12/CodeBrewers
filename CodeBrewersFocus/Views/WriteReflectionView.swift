
import SwiftUI

struct WriteReflectionView: View{
    @Binding var path: [String]
    @Binding var selectedTab: Tab
    var onCool: () -> Void = {}
    
    @State private var reflectionText = ""
    @State private var showConfirmation = false
    @FocusState private var isTextEditorFocused: Bool
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            
            // Title with icon
            HStack(alignment: .top, spacing: 8) {
                Image(systemName: "bubbles.and.sparkles.fill")
                    .font(.title)
                Text("Tree and focus")
                    .font(.largeTitle)
                    .fontWeight(.bold)
            }
            .padding(.top, 2)
            
            // Reflection input
            ZStack(alignment: .topLeading){
                TextEditor(text: $reflectionText)
                    .font(.body)
                    .lineSpacing(4)
                    .padding(.top, 2)
                //                    .frame(minHeight: 150)
                    .overlay(
                        RoundedRectangle(cornerRadius: 0)
                            .stroke(Color.clear, lineWidth: 1)
                    )
                    .focused($isTextEditorFocused)
                
                
                if reflectionText.isEmpty {
                    Text("Reflect on the relationship between your creation and focus")
                        .foregroundColor(.gray)
                        .font(.body)
                        .padding(.horizontal, 6)
                        .padding(.top, 10)
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
            .padding(.top, 10)
            .disabled(reflectionText.isEmpty)        }
        .padding()
        .overlay(
            Group {
                if showConfirmation {
                    ZStack {
                        Color.black.opacity(0.5)
                            .ignoresSafeArea()
                            .transition(.opacity)
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
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                path = []
                                onCool()
                                
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
                    .padding(.horizontal, 60)
                    .shadow(radius: 10)
                    .transition(.scale)
                }
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
