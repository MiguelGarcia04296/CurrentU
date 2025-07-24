//
//  DoneHighAppreciation.swift
//  BubbleNavApp_2.0
//
//  Created by DPI Student 141 on 7/16/25.
//
// MARK: - Completion Views

import SwiftUI

struct DoneHighAppreciation: View {
    @Binding var isPresented: Bool
    @State private var showGoalsView = false
    let goalTitle: String
    let goalDescription: String
    let goalCategory: GoalCategory
    
    var body: some View {
        BackgroundContainer {
            VStack(spacing: 20) {
                Spacer()
                
                Text("Good job creating a goal! Track Goals to stay accountable.")
                    .modifier(appTextModifier())
                //GOALS BUTTON
                Button(action: {
                    NotificationCenter.default.post(name: .dismissDailyCheckInTooltip, object: nil)
                    showGoalsView = true
                }) {
                    Text("View Goals")
                        .font(.title3)
                        .foregroundColor(.white)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 30)
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(10)
                }
                //HOME BUTTON
                Button(action: {
                    NotificationCenter.default.post(name: .dismissDailyCheckInTooltip, object: nil)
                    isPresented = false
                }) {
                    ZStack {
                        Image("bubble_icon")
                            .resizable()
                            .frame(width: 50, height: 50)
                        Image(systemName: "house.fill")
                            .foregroundColor(.white)
                            .font(.system(size: 25))
                    }
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .navigationBarBackButtonHidden(true)
        .fullScreenCover(isPresented: $showGoalsView) {
            GoalsView(isPresented: $showGoalsView, newGoal: Goal(title: goalTitle, description: goalDescription, category: goalCategory))
        }
    }
}

// Preview for dev
#Preview {
    DoneHighAppreciation(isPresented: .constant(true), goalTitle: "Sample Goal", goalDescription: "Sample Description", goalCategory: .selfCare)
}

