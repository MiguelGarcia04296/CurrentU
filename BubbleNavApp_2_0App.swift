//
//  BubbleNavApp_2_0App.swift
//  BubbleNavApp_2.0
//
//  Created by DPI Student 141 on 7/6/25.
//
import SwiftUI

@main

struct BubbleNavApp_2_0App: App {
    @State private var showLoading = true
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                if showLoading {
                    LoadingScreen()
                        .transition(.opacity)
                        .zIndex(1)
                } else {
                    ContentView()
                        .transition(.opacity)
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    withAnimation(.easeOut(duration: 0.5)) {
                        showLoading = false
                    }
                }
            }
        }
    }
}

// Custom Loading Screen View
struct LoadingScreen: View {
    var body: some View {
        ZStack {
            // Ocean background color
            LinearGradient(gradient: Gradient(colors: [Color(red: 0.7, green: 0.9, blue: 1.0), Color(red: 0.4, green: 0.7, blue: 0.9)]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            VStack(spacing: 24) {
                Spacer()
                Image("octee")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 160, height: 160)
                    .shadow(radius: 12)
                Text("CurrentU")
                    .font(.system(size: 44, weight: .bold, design: .rounded))
                    .foregroundColor(Color(red: 0.1, green: 0.3, blue: 0.5))
                    .shadow(color: Color.white.opacity(0.5), radius: 2, x: 0, y: 2)
                Spacer()
                Text("By Deniana, Dawn, Miguel")
                    .font(.footnote)
                    .foregroundColor(.white)
                    .padding(.bottom, 32)
            }
        }
    }
}




