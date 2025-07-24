//
//  DailyCheckInView.swift
//  Renamed from SecondView.swift. All references to SecondView have been updated to DailyCheckInView.
//  Created by DPI Student 141 on 7/6/25.
//  Updated for a light, modern ocean-themed UI (2025-07-16)
//
import SwiftUI

// MARK: - Daily Check-In Views
struct DailyCheckInView: View {
    @Binding var isPresented: Bool
    
    private let bas2Questions = [
        "I respect my body.",
        "I feel good about my body.",
        "I feel that my body has at least some good qualities.",
        "I take a positive attitude towards my body.",
        "I am attentive to my body's needs.",
        "I feel love for my body.",
        "I appreciate the different and unique characteristics of my body.",
        "My behavior reveals my positive attitude toward my body; for example, I walk holding my head high and smiling.",
        "I am comfortable in my body.",
        "I feel like I am beautiful even if I am different from media images of attractive people."
    ]
    
    private var randomPhrase: String {
        bas2Questions.randomElement() ?? "I respect my body."
    }
    
    // MARK: - Mark daily check-in as completed
    // This function is called when the user selects any check-in option.
    private func markDailyCheckInCompleted() {
        UserDefaults.standard.set(Date(), forKey: "lastDailyCheckInDate")
    }
    
    var body: some View {
        NavigationStack {
            BackgroundContainer {
                VStack {
                    // Header with back button
                    Spacer()
                    Spacer()
                    
                    HStack {
                        // Back button that dismisses this view
                        BackwardBubble(bubbleSize: 45) {
                            isPresented = false
                        }
                        Spacer()
                        // Page title
                        Text("Daily Check In")
                            .font(.title2)
                            .bold()
                            .foregroundColor(Color.blue)
                            .frame(maxWidth: .infinity, alignment: .center) // Center the title
                        Spacer()
                        // Invisible spacer to balance the layout
                        Color.clear.frame(width: 45, height: 45)
                    }
                    .padding(.horizontal, 40)
                    .padding(.bottom, 20)

                    Spacer()
                    
                    VStack(spacing: 20) {
                        Text("How much do you agree with the following statement? \n \n \(randomPhrase)")
                            .modifier(lightAppTextModifier())
                        NavigationLink(destination: HighAppreciationView(isPresented: $isPresented)) {
                            Text("Agree")
                                .modifier(checkInLinkModifier())
                        }
                        .simultaneousGesture(TapGesture().onEnded {
                            markDailyCheckInCompleted()
                        })
                        NavigationLink(destination: ModerateAppreciationView(isPresented: $isPresented)) {
                            Text("Somewhat Agree")
                                .modifier(checkInLinkModifier())
                        }
                        .simultaneousGesture(TapGesture().onEnded {
                            markDailyCheckInCompleted()
                        })
                        NavigationLink(destination: LowAppreciationView(isPresented: $isPresented)) {
                            Text("Disagree")
                                .modifier(checkInLinkModifier())
                        }
                        .simultaneousGesture(TapGesture().onEnded {
                            markDailyCheckInCompleted()
                        })
                        NavigationLink(destination: VLowAppreciationView(isPresented: $isPresented)) {
                            Text("Strongly Disagree")
                                .modifier(checkInLinkModifier())
                        }
                        .simultaneousGesture(TapGesture().onEnded {
                            markDailyCheckInCompleted()
                        })
                    }
                    .modifier(lightCardModifier())
                    .padding(.horizontal, 20)
                    .padding(.bottom, 60)
                    Spacer()
                }
                .padding()
                .frame(minHeight: UIScreen.main.bounds.height)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

// Preview for dev
#Preview {
    DailyCheckInView(isPresented: .constant(true))
}

