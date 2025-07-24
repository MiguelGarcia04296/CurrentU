//
//  AffirmationBubbleCard.swift
//  BubbleNavApp_2.0
//
//  Created by DPI Student 141 on 7/23/25.
//
import SwiftUI

// MARK: - Affirmation Bubble Card
// Individual affirmation cards styled like floating bubbles

struct AffirmationBubbleCard: View {
    let affirmation: Affirmation
    let toggleFavorite: () -> Void
    let useAffirmation: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            // Header with category and favorite
            HStack {
                HStack(spacing: 8) {
                    Image(systemName: affirmation.category.iconName)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white) // Changed from purple to white
                    
                    Text(affirmation.category.displayName)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.white) // Changed from purple to white
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(
                    Capsule()
                        .fill(affirmation.category.color.opacity(0.7))
                        .shadow(color: Color.purple.opacity(0.08), radius: 2)
                )
                
                Spacer()
                
                Button(action: toggleFavorite) {
                    Image(systemName: affirmation.isFavorite ? "star.fill" : "star")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(affirmation.isFavorite ? .yellow : Color.purple.opacity(0.4))
                }
                .buttonStyle(PlainButtonStyle())
            }
            
            // Affirmation text
            Text("\"\(affirmation.text)\"")
                .font(.body)
                .fontWeight(.medium)
                .foregroundColor(.purple)
                .lineLimit(4)
                .multilineTextAlignment(.leading)
            
            // Footer with usage and action
            HStack {
                Text("Used \(affirmation.timesUsed) times")
                    .font(.caption)
                    .foregroundColor(Color.purple.opacity(0.6))
                
                Spacer()
                
                Button("Dive In", action: useAffirmation)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(Color.purple.opacity(0.85))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(Color.white.opacity(0.8))
                            .shadow(color: Color.purple.opacity(0.08), radius: 2)
                    )
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.85))
                .shadow(color: Color.purple.opacity(0.08), radius: 8)
        )
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 0.1)) {
                    isPressed = false
                }
            }
        }
    }
}
