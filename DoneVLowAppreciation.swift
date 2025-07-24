//
//  DoneVLowAppreciation.swift
//  BubbleNavApp_2.0
//
//  Created by DPI Student 141 on 7/16/25.
//

import SwiftUI

struct DoneVLowAppreciation: View {
    @Binding var isPresented: Bool
    @State private var showSafetyPlanView = false
    
    // User responses from VLowAppreciationView
    let comfortableWhen: String
    let safeWhen: String
    let likeToEat: String
    
    var body: some View {
        BackgroundContainer {
            VStack(spacing: 20) {
                Spacer()
                
                Text("Good job identifying your needs. Want to review your Safety Plan?")
                    .modifier(appTextModifier())
                
                Button(action: {
                    NotificationCenter.default.post(name: .dismissDailyCheckInTooltip, object: nil)
                    showSafetyPlanView = true
                }) {
                    Text("View Safety Plan")
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
        .fullScreenCover(isPresented: $showSafetyPlanView) {
            SafetyPlanView(
                isPresented: $showSafetyPlanView,
                comfortableWhen: comfortableWhen,
                safeWhen: safeWhen,
                likeToEat: likeToEat
            )
        }
    }
}

// Preview for dev
#Preview {
    DoneVLowAppreciation(
        isPresented: .constant(true),
        comfortableWhen: "I'm with my family",
        safeWhen: "I'm in my room",
        likeToEat: "comfort foods"
    )
}


