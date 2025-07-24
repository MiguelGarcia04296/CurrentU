//
//  AnimatedBackground.swift
//  BubbleNavApp_2.0
//
//  Created by DPI Student 141 on 7/8/25.
//
import SwiftUI


// MARK: This file contains the code that would make the background look like an ocean with bubbles floating in the background. It can be referenced throughout the project.
// Now updated for a lighter, modern ocean look (2025-07-16)
// Bubble + background visual code
struct Bubble: Identifiable {
    let id = UUID()//Universally Unique Identifier assigned to each bubble
    var xOffset: CGFloat
    var size: CGFloat
    var yOffset: CGFloat = UIScreen.main.bounds.height + 50
    var horizontalDrift: CGFloat
    var opacity: Double //wider range in opacity levels
    var duration: Double //wider range in duration variation
}

struct MeshGradientView: View {
    var animationsActive: Bool = true
    @State private var isAnimating = false
    @State private var bubbles: [Bubble] = [] //each bubble duplicate has its own identity
    //bubble spawn rate
    let timer = Timer.publish(every: 0.6, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            // Lighter blue/white mesh gradient for a clean ocean look
            MeshGradient(width: 3, height: 3, points: [
                [0.0, 0.0], [0.5, 0.0], [1.0, 0.0],
                [0.0, 0.5], [animationsActive && isAnimating ? 0.1 : 0.8, 0.5], [1.0, animationsActive && isAnimating ? 0.5 : 1],
                [0.0, 1.0], [0.5, 1.0], [1.0, 1.0]
            ], colors: [
                Color("paleBlue"), Color("topBlue").opacity(0.7), Color("paleBlue"),
                Color("middleBlue").opacity(0.5), Color("middleBlue").opacity(0.7), Color("middleBlue").opacity(0.5),
                Color("paleBlue"), Color("middleBlue").opacity(0.3), Color("paleBlue")
            ])
            .ignoresSafeArea() //fills screen
            .onAppear {
                if animationsActive {
                    isAnimating = true
                } else {
                    isAnimating = false
                }
            }
            // iOS 17+ uses .onChange(animationsActive), earlier uses .onChange(of:animationsActive)
            .modifier(CompatOnChangeModifier(value: animationsActive) { newValue in
                if newValue {
                    isAnimating = true
                } else {
                    isAnimating = false
                }
            })
            
            //bubble renders in
            if animationsActive {
                ForEach(bubbles) { bubble in
                    Image("bubble_icon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: bubble.size, height: bubble.size)
                        .opacity(bubble.opacity)
                        .offset(x: bubble.xOffset, y: bubble.yOffset)
                        .animation(.easeOut(duration: bubble.duration), value: bubble.yOffset)
                }
            }
        }
        .onReceive(timer) { _ in
            if animationsActive { addBubble() }
        }
        .modifier(CompatOnChangeModifier(value: animationsActive) { newValue in
            if !newValue {
                // When turning off, clear all bubbles and stop animating
                bubbles.removeAll()
            }
        })
    }
    
    //bubble randomization
    func addBubble() {
        guard bubbles.count < 8 else { return } //no more than 15 bubbles onscreen at a time
        var newBubble = Bubble(
            xOffset: CGFloat.random(in: -150...150),//varying horizontal starting position
            size: CGFloat.random(in: 20...60),//varying size
            horizontalDrift: CGFloat.random(in: -40...40),//varying range for horizontal drift
            opacity: Double.random(in: 0.3...0.6),//varying opacity
            duration: Double.random(in: 8.0...10.0)//varying speed (duration it will be visible on screen)
        )
        bubbles.append(newBubble)
        
        //deletes offscreen bubble duplicates
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if let index = bubbles.firstIndex(where: { $0.id == newBubble.id }) {
                withAnimation(.easeOut(duration: newBubble.duration)) { //drifts at random pace
                    newBubble.yOffset = -UIScreen.main.bounds.height - 100 //ensures bubble is out of view before deleting (negative offset value means it's moving up, as offset means downwards displacement)
                    newBubble.xOffset += newBubble.horizontalDrift
                    bubbles[index] = newBubble
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + newBubble.duration) {
            if let index = bubbles.firstIndex(where: { $0.id == newBubble.id }) {
                bubbles.remove(at: index) //removes bubble from array
            }
        }
    }
}

// Background Wrapper (Keeps underwater scene behind all interactive content)
struct BackgroundContainer<Content: View>: View {
    var animationsActive: Bool = true
    let content: Content
    init(animationsActive: Bool = true, @ViewBuilder content: () -> Content) {
        self.animationsActive = animationsActive
        self.content = content()
    }
    var body: some View {
        ZStack {
            MeshGradientView(animationsActive: animationsActive)
            content
        }
        // Removed .preferredColorScheme(.dark) for light theme
    }
}
