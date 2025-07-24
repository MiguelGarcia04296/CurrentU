//
//  DoneModerateAppreciation.swift
//  BubbleNavApp_2.0
//
//  Created by DPI Student 141 on 7/16/25.
//

import SwiftUI

struct DoneModerateAppreciation: View {
    @Binding var isPresented: Bool
    @State private var showAffirmationView = false
    let affirmationText: String
    let affirmationCategory: Affirmation.CategoryKey
    
    var body: some View {
        BackgroundContainer {
            VStack(spacing: 20) {
                Spacer()
                
                Text("Good job creating an affirmation!")
                    .modifier(appTextModifier())
                
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
            AffirmationView(isPresented: $showAffirmationView, newAffirmation: Affirmation(id: UUID(), text: affirmationText, category: affirmationCategory))
        }
    }
}

// Preview for dev
#Preview {
    DoneModerateAppreciation(isPresented: .constant(true), affirmationText: "I am worthy of love", affirmationCategory: .selfLove)
}


