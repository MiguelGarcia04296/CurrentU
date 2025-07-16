//
//  FifthView.swift
//  BubbleNavApp_2.0
//
//  Created by DPI Student 141 on 7/8/25.
//  Updated for a light, modern ocean-themed UI (2025-07-16)
//
import SwiftUI
// Import lightCardModifier for light, modern card backgrounds
// (Defined in sharedComponents.swift)

// MARK: - Bubble Button Components
/// Custom bubble-styled back button that matches the app's design theme
struct BackwardBubble: View {
    let bubbleSize: CGFloat  // Size of the bubble button
    let action: () -> Void   // Closure that defines what happens when button is tapped
    
    var body: some View {
        Button(action: action) {
            ZStack {
                // Background bubble image
                Image("bubble_icon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: bubbleSize, height: bubbleSize)
                
                // Arrow icon overlaid on the bubble
                Image(systemName: "arrowshape.backward.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.white)
                    .frame(width: bubbleSize - 15, height: bubbleSize - 15)
            }
            .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(PlainButtonStyle()) // Prevents default button styling
    }
}

// MARK: - Goal Model
/// Data model representing a single goal
/// Identifiable: Allows SwiftUI to track each goal uniquely in lists
/// Hashable: Enables goals to be used in sets and as dictionary keys
struct Goal: Identifiable, Hashable {
    let id = UUID()              // Unique identifier for each goal
    let title: String            // Main goal text (e.g., "Drink 8 glasses of water")
    let description: String      // Detailed explanation of the goal
    var isCompleted: Bool = false // Tracks completion status
}

// MARK: - Goals Page View
/// Main view that displays the list of goals with completion and deletion functionality
struct GoalsView: View {
    @Binding var isPresented: Bool // Controls whether this view is shown or dismissed
    
    // MARK: - State Variables
    /// Array of goals that users can interact with
    /// @State makes this mutable and triggers UI updates when changed
    @State private var goals = [
        Goal(title: "Drink 8 glasses of water daily", description: "Stay hydrated throughout the day for better energy and health"),
        Goal(title: "Practice 10 minutes of meditation", description: "Take time to center yourself and reduce stress"),
        Goal(title: "Take a 30-minute walk", description: "Get some fresh air and light exercise to boost your mood"),
        Goal(title: "Write 3 things I'm grateful for", description: "Focus on positive aspects of your day and life"),
        Goal(title: "Eat 5 servings of fruits/vegetables", description: "Nourish your body with colorful, healthy foods"),
        Goal(title: "Get 8 hours of sleep", description: "Prioritize rest for mental and physical recovery"),
        Goal(title: "Practice positive self-talk", description: "Be kind to yourself and challenge negative thoughts"),
        Goal(title: "Connect with a friend or family member", description: "Maintain meaningful relationships and social connections")
    ]
    
    // MARK: - Loading State
    @State private var loading: Bool = true
    
    // MARK: - Delete Functionality State Variables
    @State private var goalToDelete: Goal? = nil        // Stores which goal is selected for deletion
    @State private var showDeleteConfirmation = false   // Controls the delete confirmation dialog
    @State private var showSuccessToast = false         // Controls the success message display
    @State private var goalJustCompleted: Goal?         // Tracks goals that were just completed

    // MARK: - New Goal Form State
    @State private var showGoalForm = false // Controls whether the new goal form is visible
    @State private var newGoalTitle = ""    // Stores the new goal's title
    @State private var newGoalDescription = "" // Stores the new goal's description
    
    var body: some View {
        BackgroundContainer {
            ZStack {
                if loading {
                    VStack(spacing: 20) {
                        Image("bubble_icon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .opacity(0.7)
                        Text("Preparing for a productive day...")
                            .frame(width: 380)
                            .font(.title3)
                            .fontWeight(.medium)
                            .foregroundColor(.blue)
                            .shadow(color: .blue.opacity(0.1), radius: 2)
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                            .scaleEffect(1.5)
                    }
                } else {
                    VStack(alignment: .leading) {
                        // MARK: - Header Section
                        // Contains back button, title, and spacing
                        HStack {
                            // Back button that dismisses this view
                            BackwardBubble(bubbleSize: 45) {
                                isPresented = false
                            }
                            Spacer()
                            // Page title
                            Text("My Goals")
                                .font(.largeTitle)
                                .bold()
                                .foregroundColor(.blue)
                            Spacer()
                            // Invisible spacer to balance the layout
                            Color.clear.frame(width: 20, height: 150)
                        }
                        .padding(.horizontal, 40)

                        // MARK: - Floating Add Button
                        HStack {
                            Spacer()
                            Button(action: {
                                // Show the new goal form
                                withAnimation(.spring()) { showGoalForm = true }
                            }) {
                                ZStack {
                                    Circle()
                                        .fill(Color.white.opacity(0.8))
                                        .frame(width: 60, height: 60)
                                        .shadow(color: .blue.opacity(0.1), radius: 5)
                                    Image(systemName: "plus")
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundColor(.blue)
                                }
                                Spacer()
                            }
                            .padding()
                        }

                        // MARK: - Bubble-Themed New Goal Form
                        if showGoalForm {
                            HStack {
                                Spacer()
                                VStack(spacing: 20) {
                                    Text("Create New Goal")
                                        .font(.headline)
                                        .fontWeight(.bold)
                                        .foregroundColor(.blue)
                                    // Title input field
                                    TextField("Goal title...", text: $newGoalTitle)
                                        .modifier(lightTextFieldModifier())
                                        .frame(maxWidth: .infinity)
                                        .background(
                                            RoundedRectangle(cornerRadius: 15)
                                                .fill(Color.white.opacity(0.5))
                                                .shadow(color: .black.opacity(0.2), radius: 5)
                                        )
                                        .foregroundColor(.white)
                                    // Description input field
                                    TextField("Goal description...", text: $newGoalDescription)
                                        .modifier(lightTextFieldModifier())
                                        .frame(maxWidth: .infinity)
                                        .background(
                                            RoundedRectangle(cornerRadius: 15)
                                                .fill(Color.white.opacity(0.5))
                                                .shadow(color: .black.opacity(0.1), radius: 5)
                                        )
                                        .foregroundColor(.white)
                                    // Action buttons
                                    HStack(spacing: 15) {
                                        Button("Create") {
                                            if !newGoalTitle.isEmpty && !newGoalDescription.isEmpty {
                                                goals.append(Goal(title: newGoalTitle, description: newGoalDescription))
                                                newGoalTitle = ""
                                                newGoalDescription = ""
                                                showGoalForm = false
                                            }
                                        }
                                        .disabled(newGoalTitle.isEmpty || newGoalDescription.isEmpty)
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 10)
                                        .background(
                                            Capsule()
                                                .fill(Color.blue)
                                                .shadow(color: .blue.opacity(0.1), radius: 3)
                                        )
                                        Button("Cancel") {
                                            withAnimation(.spring()) {
                                                showGoalForm = false
                                                newGoalTitle = ""
                                                newGoalDescription = ""
                                            }
                                        }
                                        .font(.headline)
                                        .foregroundColor(.blue)
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 10)
                                        .background(
                                            Capsule()
                                                .stroke(Color.blue.opacity(0.5), lineWidth: 1)
                                        )
                                    }
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(Color.white.opacity(0.9))
                                        .shadow(color: .blue.opacity(0.08), radius: 10)
                                )
                                .frame(maxWidth: 600) // Match max width of goal cards
                                Spacer()
                            }
                            .padding(.horizontal, 20)
                            .transition(.opacity)
                        }

                        // MARK: - Goals List Section
                        // Scrollable list of goal cards
                        ScrollView {
                            LazyVStack(spacing: 20) {
                                // ForEach iterates through goal indices to allow binding
                                ForEach(goals.indices, id: \.self) { index in
                                    GoalCard(
                                        goal: $goals[index], // Binding allows the card to modify the goal
                                        onToggle: {
                                            // Handle goal completion toggle
                                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                                goals[index].isCompleted.toggle()
                                            }
                                            // If goal was just completed, show success message and auto-delete
                                            if goals[index].isCompleted {
                                                goalJustCompleted = goals[index]
                                                showSuccessToast = true
                                                // Auto-delete completed goal after 3 seconds
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                                    withAnimation {
                                                        showSuccessToast = false
                                                        if let goalToRemove = goalJustCompleted {
                                                            goals.removeAll { $0.id == goalToRemove.id }
                                                            goalJustCompleted = nil
                                                        }
                                                    }
                                                }
                                            }
                                        },
                                        onDelete: {
                                            // Handle manual deletion
                                            goalToDelete = goals[index]
                                            showDeleteConfirmation = true
                                        }
                                    )
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 100) // Extra padding for safe area
                        }
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true) // Hide default navigation back button
        // MARK: - Delete Confirmation Dialog
        .alert("Are you sure you want to delete this goal?",
               isPresented: $showDeleteConfirmation,
               presenting: goalToDelete) { goal in
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) {
                withAnimation {
                    goals.removeAll { $0.id == goal.id }
                }
            }
        }
        // MARK: - Success Toast Message
        .toast(isShowing: $showSuccessToast, message: "Way to go!")
        .onAppear {
            // Simulate loading delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                loading = false
            }
        }
    }
}

// MARK: - Goal Card Component
/// Individual goal card that displays goal info and handles user interactions
struct GoalCard: View {
    @Binding var goal: Goal        // Binding to the goal data
    let onToggle: () -> Void       // Callback for when goal is marked complete
    let onDelete: () -> Void       // Callback for when delete button is tapped
    
    var body: some View {
        HStack(spacing: 15) {
            // MARK: - Completion Toggle Button
            // Checkmark circle that toggles goal completion
            Button(action: onToggle) {
                ZStack {
                    // Outer circle (always visible)
                    Circle()
                        .stroke(Color.blue.opacity(0.3), lineWidth: 2)
                        .frame(width: 24, height: 24)
                    
                    // Inner circle and checkmark (only when completed)
                    if goal.isCompleted {
                        Circle()
                            .fill(Color.blue.opacity(0.7))
                            .frame(width: 24, height: 24)
                        
                        Image(systemName: "checkmark")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: goal.isCompleted)
            }
            .buttonStyle(PlainButtonStyle())
            
            // MARK: - Goal Content Section
            VStack(alignment: .leading, spacing: 8) {
                // Goal title with strikethrough when completed
                Text(goal.title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.blue)
                    .multilineTextAlignment(.leading)
                    .strikethrough(goal.isCompleted, color: .blue.opacity(0.5))
                
                // Goal description
                Text(goal.description)
                    .font(.subheadline)
                    .foregroundColor(.blue.opacity(0.7))
                    .multilineTextAlignment(.leading)
                    .lineLimit(nil)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // MARK: - Delete Button
            // X button for manual goal deletion
            Button(action: onDelete) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.blue.opacity(0.4))
                    .font(.system(size: 18))
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(20)
        // MARK: - Card Background Styling
        .modifier(lightCardModifier())
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(
                    goal.isCompleted ?
                    Color.green.opacity(0.4) :     // Green border when completed
                    Color.blue.opacity(0.15),      // Default light border
                    lineWidth: 1
                )
        )
        // Slight scale effect when completed
        .scaleEffect(goal.isCompleted ? 0.98 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: goal.isCompleted)
    }
}

// MARK: - Toast Extension
/// Custom toast notification for showing success messages
extension View {
    func toast(isShowing: Binding<Bool>, message: String) -> some View {
        ZStack {
            self
            if isShowing.wrappedValue {
                Text(message)
                    .padding()
                    .background(Color.black.opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .transition(.opacity)                    // Fade in/out animation
                    .zIndex(1)                              // Always on top
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.clear)
            }
        }
        .animation(.easeInOut, value: isShowing.wrappedValue)
    }
}

// MARK: - Preview
#Preview {
    GoalsView(isPresented: .constant(true))
}
