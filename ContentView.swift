//
//  ContentView.swift
//  BubbleNavApp_2.0
//
//  Created by DPI Student 141 on 7/6/25.
//

import SwiftUI

// MARK: This is the code for the homescreen of CurrentU where the user can access their Safety Plan, Daily Check In, Affirmations List, Thought Reframer and Goals page. All of the buttons used to access the pages are buttons that lead to other views. The buttons look like bubbles to keep the undersea theme.

struct ContentView: View {
    
    
    
    // MARK: State Variables
    // These control which view is currently being presented
    
    @State private var showSafetyPlanView = false
    @State private var showDailyCheckInView = false
    @State private var showThirdView = false
    @State private var showThoughtReframeView = false
    @State private var showGoalsView = false
    @State private var animationsActive: Bool = true
    
    // MARK: Daily Check-in Tracking
    // Track whether user has completed daily check-in today
    @State private var hasCompletedDailyCheckIn: Bool = false
    
    // MARK: Octee Animation State
    @State private var octeeOffset: CGSize = .zero
    @State private var octeeRotation: Double = 0.0
    
    // MARK: Customizable Bubble Properties
    // Edit these values to easily change bubble size and positions
    private let bubbleSize: CGFloat = 80           // Size of all bubbles
    
    private let firstBubblePosition = CGPoint(x: 85, y: 100)    // Top-left bubble
    private let secondBubblePosition = CGPoint(x: 325, y: 200)   // Top-right bubble
    private let thirdBubblePosition = CGPoint(x: 85, y: 300)    // Bottom-left bubble
    private let fourthBubblePosition = CGPoint(x: 325, y: 400)   // Bottom-right bubble
    private let fifthBubblePosition = CGPoint(x: 85, y: 500)
    
    var body: some View {
        
        NavigationView {
            
            ZStack(alignment: .topTrailing) {
                
                // Main Container with Animated Background and interactive content
                BackgroundContainer(animationsActive: animationsActive) {
                    
                    
                    // Coral foreground fixed at the bottom center
                    coralForeground()
                        .position(x:200 , y: 525)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                        .ignoresSafeArea()
                        
                    
                    ZStack {
                        
                        // MARK: Animated Octee
                        Image("octee")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 300.0, height: 300.0)
                            .offset(octeeOffset)
                            .rotationEffect(.degrees(octeeRotation))
                            .onAppear {
                                if animationsActive {
                                    startOcteeAnimation()
                                } else {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        octeeOffset = .zero
                                        octeeRotation = 0.0
                                    }
                                }
                            }
                            .modifier(CompatOnChangeModifier(value: animationsActive) { newValue in
                                if newValue {
                                    withAnimation(.easeInOut(duration: 0.1)) {
                                        octeeOffset = .zero
                                        octeeRotation = 0.0
                                    }
                                    startOcteeAnimation()
                                } else {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        octeeOffset = .zero
                                        octeeRotation = 0.0
                                    }
                                }
                            })
                        
                        // MARK: Bubble Layout
                        
                        // Each bubble is positioned individually and can be easily customized
                        
                        CustomizableBubble(
                            contentImageName: "bottle",
                            label: "Safety Plan",
                            bubbleSize: bubbleSize * 1.25 ,
                            position: firstBubblePosition,
                            action: {
                                showSafetyPlanView = true  // Show SafetyPlanView when tapped
                            },
                            animationsActive: animationsActive,
                            outlineColor: nil,
                            outlineLineWidth: 5
                        ).padding([.top, .leading, .bottom], 0.5)
                        
                        //                    MARK: Daily Check In Bubble
                        CustomizableBubble(
                            contentImageName: "compass",
                            label: "Daily Check in",
                            bubbleSize: bubbleSize * 1.20,
                            position: secondBubblePosition,
                            action: {
                                showDailyCheckInView = true  // Show DailyCheckInView when tapped
                            },
                            animationsActive: animationsActive,
                            outlineColor: hasCompletedDailyCheckIn ? nil : Color.orange,
                            outlineLineWidth: 5
                        ).padding([.top, .leading, .bottom], 0.5)
                        
                        
                        //                    MARK: Affirmations Bubble
                        CustomizableBubble(
                            contentImageName: "pearls",
                            label: "Affirmations",
                            bubbleSize: bubbleSize * 1.15,
                            position: thirdBubblePosition,
                            action: {
                                showThirdView = true  // Show ThirdView when tapped
                            },
                            animationsActive: animationsActive,
                            outlineColor: nil,
                            outlineLineWidth: 5
                        ).padding([.top, .leading, .bottom], 0.5)
                        
                        //                    MARK: Thought Reframe BUBBLE
                        CustomizableBubble(
                            contentImageName: "shell",     // Placeholder SF Symbol
                            label: "Thought Reframe",
                            bubbleSize: bubbleSize * 1.20,
                            position: fourthBubblePosition,
                            action: {
                                showThoughtReframeView = true  // Show ThoughtReframeView when tapped
                            },
                            animationsActive: animationsActive,
                            outlineColor: nil,
                            outlineLineWidth: 5
                        ).padding([.top, .leading, .bottom], 0.5)
                        
                        //                    MARK: GOAL BUBBLE
                        CustomizableBubble(
                            contentImageName: "leaf",
                            label: "Goal",
                            bubbleSize: bubbleSize * 1.25,
                            position: fifthBubblePosition,
                            action: {
                                showGoalsView = true  // Show GoalsView when tapped
                            },
                            animationsActive: animationsActive,
                            outlineColor: nil,
                            outlineLineWidth: 5
                        ).padding([.top, .leading, .bottom], 0.5)
                        
                    }
                    .navigationBarHidden(true)  // Hide navigation bar on main screen
                }
                // Animation Toggle Button (fixed at top right, icon only)
                AnimationToggleButton(isOn: $animationsActive)
                    .padding(.top, 8)
                    .padding(.trailing, 8)
            }
        }
        // MARK: - Navigation Logic
        // Each view gets its own fullScreenCover for clean presentation
        
        .fullScreenCover(isPresented: $showSafetyPlanView) {
            SafetyPlanView(isPresented: $showSafetyPlanView, comfortableWhen: "", safeWhen: "", likeToEat: "")
        }
        .fullScreenCover(isPresented: $showDailyCheckInView) {
            DailyCheckInView(isPresented: $showDailyCheckInView)
                .onDisappear {
                    // Check if user completed daily check-in when returning to main screen
                    checkDailyCheckInStatus()
                }
        }
        .fullScreenCover(isPresented: $showThirdView) {
            AffirmationView(isPresented: $showThirdView, newAffirmation: nil)
        }
        .fullScreenCover(isPresented: $showThoughtReframeView) {
            ThoughtReframeView(isPresented: $showThoughtReframeView)
        }
        .fullScreenCover(isPresented: $showGoalsView) {
            GoalsView(isPresented: $showGoalsView, newGoal: nil)
        }
    }
    
    // MARK: - Daily Check-in Helper Functions
    
    /// Check if user has completed daily check-in today
    private func checkDailyCheckInStatus() {
        let today = Calendar.current.startOfDay(for: Date())
        let lastCheckInDate = UserDefaults.standard.object(forKey: "lastDailyCheckInDate") as? Date
        
        // Reset daily check-in if it's a new day
        if let lastDate = lastCheckInDate {
            let lastCheckInDay = Calendar.current.startOfDay(for: lastDate)
            hasCompletedDailyCheckIn = Calendar.current.isDate(today, inSameDayAs: lastCheckInDay)
        } else {
            hasCompletedDailyCheckIn = false
        }
    }
    
    /// Mark daily check-in as completed
    private func markDailyCheckInCompleted() {
        UserDefaults.standard.set(Date(), forKey: "lastDailyCheckInDate")
        hasCompletedDailyCheckIn = true
    }
    
    // MARK: Octee Animation Function
    private func startOcteeAnimation() {
        let randomDelay = Double.random(in: 0...1)
        withAnimation(
            Animation.easeInOut(duration: Double.random(in: 4...5))
                .repeatForever(autoreverses: true)
                .delay(randomDelay)
        ) {
            octeeOffset = CGSize(
                width: Double.random(in: -8...8),
                height: Double.random(in: -8...8)
            )
        }
        let rotationDelay = Double.random(in: 0...1)
        withAnimation(
            Animation.easeInOut(duration: Double.random(in: 6...7))
                .repeatForever(autoreverses: true)
                .delay(rotationDelay)
        ) {
            octeeRotation = Double.random(in: -4...4)
        }
    }
}

// MARK: - Notification Extension
extension Notification.Name {
    static let dismissDailyCheckInTooltip = Notification.Name("dismissDailyCheckInTooltip")
}

// MARK: Preview
#Preview {
    ContentView()
}

// Animation Toggle Button
struct AnimationToggleButton: View {
    @Binding var isOn: Bool
    var body: some View {
        Button(action: { isOn.toggle() }) {
            Image(systemName: isOn ? "wave.3.forward" : "water.waves")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.white)
                .padding(10)
                .background(
                    Circle()
                        .fill(
                            LinearGradient(gradient: Gradient(colors: [Color("topBlue"), Color("middleBlue")]), startPoint: .top, endPoint: .bottom)
                        )
                )
                .shadow(color: Color("middleBlue").opacity(0.3), radius: 4, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
        .accessibilityLabel("Toggle homescreen animation")
    }
}

