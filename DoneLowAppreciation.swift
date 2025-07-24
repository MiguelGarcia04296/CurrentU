//
//  DoneLowAppreciation.swift
//  BubbleNavApp_2.0
//
//  Created by DPI Student 141 on 7/16/25.
//

import SwiftUI

struct DoneLowAppreciation: View {
    @Binding var isPresented: Bool
    @State private var showAffirmationView = false
    
    var body: some View {
        BackgroundContainer {
            VStack(spacing: 20) {
                Spacer()
                
                Text("Good job creating this affirmation!")
                    .modifier(appTextModifier())
                //AFFIRMATIONS BUTTON
                Button(action: {
                    NotificationCenter.default.post(name: .dismissDailyCheckInTooltip, object: nil)
                    showAffirmationView = true
                }) {
                    Text("View Affirmations")
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
        .fullScreenCover(isPresented: $showAffirmationView) {
            AffirmationView(isPresented: $showAffirmationView, newAffirmation: nil)
        }
    }
}

// Preview for dev
#Preview {
    DoneLowAppreciation(isPresented: .constant(true))
}

