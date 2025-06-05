//
//  ContentView.swift
//  AIanalysis
//
//  Created by Megha Elisa George on 4/6/2025.
//

import SwiftUI

struct AnalysisView: View {
    var body: some View {
        HStack {
            Image(systemName: "chevron.backward")
                .font(.system(size: 20))
                .foregroundStyle(.gray)
                Spacer()
                Text("Well Done")
                Spacer()
                .font(.caption)
                .fontWeight(.semibold)
                Image(systemName: "xmark")
                .font(.system(size: 20))
                .foregroundStyle(.gray)
        }
        .padding(.horizontal)
        .padding(.top, 0)
        VStack{
            Text("It's a Tree!")
                .font(.largeTitle)
                .fontWeight(.bold)
            Text("A symbol of resilience and growth.")
            Image("maintree")
                .resizable()
                .frame(width: 400, height: 500)
        }
        HStack{
            Toggle(isOn: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Is On@*/.constant(true)/*@END_MENU_TOKEN@*/) {
            }
            //.padding(.horizontal, 80)
            Text("Make the creation visible in Explore")
                .padding(.horizontal, 30)
        }
        HStack(spacing: 6){
            Image(systemName: "bubbles.and.sparkles.fill")
            Text("Reflect")
        }
        .fontWeight(.bold)
        .frame(maxWidth: .infinity)
        .padding()
        .cornerRadius(25)
        .background(Color.blue)
        .foregroundColor(.white)
        .cornerRadius(25)
        
    }
}

#Preview {
    AnalysisView()
}
