//
//  LandingPageView.swift
//  CodeBrewersFocus
//
//  Created by Megha Elisa George on 10/6/2025.
//
import SwiftUI

struct LandingPageView: View {
    @State private var logoScale: CGFloat = 0.0

    var body: some View {
        ZStack {
            // Background
            Image("Spotlight")
            //Color.white
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
            VStack(spacing: 30) {
                // Logo
                Image("Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 200)
                    .scaleEffect(logoScale)
                    .onAppear {
                        withAnimation(.interpolatingSpring(stiffness: 30, damping: 8)) {
                            logoScale = 1.0
                        }
                    }
                }
            }
        }
    }
