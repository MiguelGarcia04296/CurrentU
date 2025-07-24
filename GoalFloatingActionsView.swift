//
//  GoalFloatingActionsView.swift
//  BubbleNavApp_2.0
//
//  Created by DPI Student 141 on 7/23/25.
//

import SwiftUI

struct GoalFloatingActionsView: View {
    let selectedFilter: GoalCategory?
    let onAddGoal: () -> Void
    let onFilterChange: (GoalCategory?) -> Void
    
    var body: some View {
        HStack(spacing: 20) {
            // Add goal bubble button
            Button(action: onAddGoal) {
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.8))
                        .frame(width: 48, height: 48)
                        .shadow(color: .blue.opacity(0.1), radius: 5)
                    
                    Image(systemName: "plus")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.blue)
                }
            }
            
            // Category filter picker
            Picker("Filter", selection: Binding(
                get: { selectedFilter },
                set: { onFilterChange($0) }
            )) {
                Text("All Categories").tag(GoalCategory?.none)
                ForEach(GoalCategory.allCases) { category in
                    Text(category.displayName).tag(Optional(category))
                }
            }
            .pickerStyle(MenuPickerStyle())
            .foregroundColor(selectedFilter?.color ?? .blue)
            .padding(.horizontal, 15)
            .padding(.vertical, 8)
            .background(
                Capsule()
                    .fill(Color.white.opacity(0.8))
                    .shadow(color: Color.blue.opacity(0.08), radius: 3)
            )
        }
    }
} 
