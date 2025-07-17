//
//  FirstView.swift
//  BubbleNavApp_2.0
//
//  Created by DPI Student 141 on 7/6/25.
//
import SwiftUI

struct FirstView: View {
    @Binding var isPresented: Bool
    
    // User responses from VLowAppreciationView
    let comfortableWhen: String
    let safeWhen: String
    let likeToEat: String
    
    // State variables for selectable coping mechanisms
    @State private var selectedCopingMechanisms: Set<String> = []
    
    // Animation state for octopus bobbing
    @State private var octopusOffset: CGFloat = 0
    
    // Coping mechanisms for eating disorders
    let copingMechanisms = [
        "Practice mindful eating",
        "Eat with supportive people",
        "Practice deep breathing",
        "Call a trusted friend",
        "Take a walk",
        "Listen to calming music",
        "Write in a journal",
    ]
    
    // Initializer with default values for backward compatibility
    init(isPresented: Binding<Bool>, comfortableWhen: String = "", safeWhen: String = "", likeToEat: String = "") {
        self._isPresented = isPresented
        self.comfortableWhen = comfortableWhen
        self.safeWhen = safeWhen
        self.likeToEat = likeToEat
    }
    
    var body: some View {
        ZStack {
            // Custom muted blue gradient background for safety plan
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.1, green: 0.2, blue: 0.4),
                    Color(red: 0.15, green: 0.25, blue: 0.5),
                    Color(red: 0.2, green: 0.3, blue: 0.6)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading, spacing: 24) {
                
                // Navigation bar with back button and title
                HStack {
                    Button(action: {
                        isPresented = false
                    }) {
                        Image(systemName: "arrow.backward")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    Text("Safety Plan")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Spacer() // placeholder for alignment
                }
                .padding(.horizontal)
                
                // Emergency contact buttons
                VStack(spacing: 12) {
                    Button(action: {
                        if let url = URL(string: "tel:911") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        HStack {
                            Text("Emergency: 911")
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                            Spacer()
                            Image(systemName: "phone.fill")
                                .foregroundColor(.white)
                        }
                        .padding()
                        .background(Color.red.opacity(0.8))
                        .cornerRadius(12)
                    }
                    
                    Button(action: {
                        if let url = URL(string: "tel:988") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        HStack {
                            Text("Suicide Prevention: 988")
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                            Spacer()
                            Image(systemName: "phone.fill")
                                .foregroundColor(.white)
                        }
                        .padding()
                        .background(Color.orange.opacity(0.8))
                        .cornerRadius(12)
                    }
                }
                .padding(.horizontal)
                
                // Coping mechanisms checklist
                VStack(alignment: .leading, spacing: 16) {
                    Text("Coping Mechanisms")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal)
                    
                    VStack(spacing: 12) {
                        ForEach(copingMechanisms, id: \.self) { mechanism in
                            Button(action: {
                                if selectedCopingMechanisms.contains(mechanism) {
                                    selectedCopingMechanisms.remove(mechanism)
                                } else {
                                    selectedCopingMechanisms.insert(mechanism)
                                }
                            }) {
                                HStack {
                                    Text(mechanism)
                                        .foregroundColor(.white)
                                        .multilineTextAlignment(.leading)
                                    Spacer()
                                    Image(systemName: selectedCopingMechanisms.contains(mechanism) ? "checkmark.circle.fill" : "circle")
                                        .foregroundColor(selectedCopingMechanisms.contains(mechanism) ? .green : .white.opacity(0.6))
                                        .font(.system(size: 20))
                                }
                            }
                        }
                    }
                    .padding()
                    .background(Color.black.opacity(0.3))
                    .cornerRadius(16)
                    .padding(.horizontal)
                }
                
                // Personal comfort prompts
                VStack(alignment: .leading, spacing: 12) {
                    Text("Personal Comfort Prompts")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("I'm comfortable when...")
                                .foregroundColor(.white.opacity(0.8))
                            Text(comfortableWhen.isEmpty ? "Not specified" : comfortableWhen)
                                .foregroundColor(.white)
                                .fontWeight(.medium)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("I feel safe when...")
                                .foregroundColor(.white.opacity(0.8))
                            Text(safeWhen.isEmpty ? "Not specified" : safeWhen)
                                .foregroundColor(.white)
                                .fontWeight(.medium)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("I like to eat...")
                                .foregroundColor(.white.opacity(0.8))
                            Text(likeToEat.isEmpty ? "Not specified" : likeToEat)
                                .foregroundColor(.white)
                                .fontWeight(.medium)
                        }
                    }
                    .padding()
                    .background(Color.black.opacity(0.3))
                    .cornerRadius(16)
                    .padding(.horizontal)
                }
                
                Spacer()
            }
            
            // Animated octopus image
            VStack {
                Spacer()
                HStack {
                    Image("octee")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250)
                        .offset(x: 115, y: octopusOffset + 40)
                        .padding()
                }
            }
        }
        .onAppear {
            // Start octopus bobbing animation
            withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                octopusOffset = -10
            }
        }
    }
}

// Preview for development
#Preview {
    FirstView(isPresented: .constant(true))
}
