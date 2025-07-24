//
//  GoalsView.swift
//  BubbleNavApp_2.0
//
//  Created by DPI Student 141 on 7/8/25.
//
//  This file implements the Goals page, where users can create, edit, complete, and delete personal goals.
//  It includes:
//    - Data models for goals and categories
//    - The main view for displaying, filtering, and managing goals
//    - UI components for goal cards, add/edit forms, and toast notifications
//    - Ocean-themed design with bubble buttons and light card backgrounds
//  All major code sections are commented for clarity.
//
import SwiftUI
// Import lightCardModifier for light, modern card backgrounds
// (Defined in sharedComponents.swift)

// MARK: - Bubble Button Components
// Custom back button styled as a bubble for navigation
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

// MARK: - Goal Category Enum (from finalGoals)
// Enum for all possible goal categories, with display names, colors, and icons
enum GoalCategory: String, CaseIterable, Identifiable {
    case selfCare = "self_care"
    case therapy, nutrition, fitness, social, mindfulness, recovery
    var id: String { rawValue }
    var displayName: String {
        switch self {
        case .selfCare: return "Self Care"
        case .therapy: return "Therapy"
        case .nutrition: return "Nutrition"
        case .fitness: return "Fitness"
        case .social: return "Social"
        case .mindfulness: return "Mindfulness"
        case .recovery: return "Recovery"
        }
    }
    var color: Color {
        switch self {
        case .selfCare: return Color("categoryPink")
        case .therapy: return Color("categoryPurple")
        case .nutrition: return Color("categoryGreen")
        case .fitness: return Color("categoryBlue")
        case .social: return Color("categoryYellow")
        case .mindfulness: return Color("categoryRed")
        case .recovery: return Color("categoryPurple")
        }
    }
    
    var iconName: String {
        switch self {
        case .selfCare: return "heart.fill"
        case .therapy: return "brain.head.profile"
        case .nutrition: return "leaf.fill"
        case .fitness: return "figure.walk"
        case .social: return "person.2.fill"
        case .mindfulness: return "sparkles"
        case .recovery: return "arrow.clockwise"
        }
    }
}

// MARK: - Goal Model
// Data model representing a single goal
// Identifiable: Allows SwiftUI to track each goal uniquely in lists
// Hashable: Enables goals to be used in sets and as dictionary keys
struct Goal: Identifiable, Hashable {
    let id: UUID // Use stored property for easier editing
    var title: String
    var description: String
    var category: GoalCategory
    var isCompleted: Bool = false
    // For compatibility with old goals, add an init
    init(id: UUID = UUID(), title: String, description: String, category: GoalCategory = .selfCare, isCompleted: Bool = false) {
        self.id = id
        self.title = title
        self.description = description
        self.category = category
        self.isCompleted = isCompleted
    }
}

// MARK: - Goals Page View
// Main view that displays the list of goals with completion and deletion functionality
struct GoalsView: View {
    @Binding var isPresented: Bool // Controls whether this view is shown or dismissed
    let newGoal: Goal? // Optional new goal to add from appreciation view
    
    // MARK: - State Variables
    // State for goals, loading, delete confirmation, form, and filtering
    /// Array of goals that users can interact with
    /// @State makes this mutable and triggers UI updates when changed
    @State private var goals = [
        Goal(title: "Drink 8 glasses of water daily", description: "Stay hydrated throughout the day for better energy and health", category: .nutrition),
        Goal(title: "Practice 10 minutes of meditation", description: "Take time to center yourself and reduce stress", category: .mindfulness),
        Goal(title: "Take a 30-minute walk", description: "Get some fresh air and light exercise to boost your mood", category: .fitness),
        Goal(title: "Write 3 things I'm grateful for", description: "Focus on positive aspects of your day and life", category: .selfCare),
        Goal(title: "Eat 5 servings of fruits/vegetables", description: "Nourish your body with colorful, healthy foods", category: .nutrition),
        Goal(title: "Get 8 hours of sleep", description: "Prioritize rest for mental and physical recovery", category: .selfCare),
        Goal(title: "Practice positive self-talk", description: "Be kind to yourself and challenge negative thoughts", category: .therapy),
        Goal(title: "Connect with a friend or family member", description: "Maintain meaningful relationships and social connections", category: .social)
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
    @State private var editingGoal: Goal? = nil // For editing
    @State private var newGoalCategory: GoalCategory = .selfCare // For new/edit form
    @State private var selectedFilter: GoalCategory? = nil // For filtering goals
    
    var body: some View {
        BackgroundContainer {
            ZStack {
                if loading {
                    // Loading screen with ocean theme
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
                            Spacer()
                            // Page title
                            Text("My Goals")
                                .font(.largeTitle)
                                .bold()
                                .foregroundColor(.blue)
                                .frame(maxWidth: .infinity, alignment: .center) // Center the title
                            Spacer()
                            // Invisible spacer to balance the layout
                            Color.clear.frame(width: 45, height: 45)
                        }
                        .padding(.horizontal, 40)
                        .padding(.bottom, 20)

                        Spacer()

                        // MARK: - Floating Add Button and Category Filter
                        // Add goal button and filter picker
                        HStack(spacing: 20) {
                            // Add goal bubble button
                            Button(action: {
                                editingGoal = nil
                                newGoalTitle = ""
                                newGoalDescription = ""
                                newGoalCategory = .selfCare
                                withAnimation(.spring()) { showGoalForm = true }
                            }) {
                                ZStack {
                                    Circle()
                                        .fill(Color.white.opacity(0.8))
                                        .frame(width: 48, height: 48) // Smaller plus button
                                        .shadow(color: .blue.opacity(0.1), radius: 5)
                                    Image(systemName: "plus")
                                        .font(.system(size: 14, weight: .bold)) // Smaller plus sign
                                        .foregroundColor(.blue)
                                }
                            }
                            // Category filter picker
                            Picker("Filter", selection: $selectedFilter) {
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
                        .padding(.horizontal, 40)
                        
                        Spacer()
                        Spacer()


                        // MARK: - Bubble-Themed New/Edit Goal Form
                        // Form for creating or editing a goal
                        if showGoalForm {
                            HStack {
                                Spacer()
                                VStack(spacing: 20) {
                                    Text(editingGoal == nil ? "Create New Goal" : "Edit Goal")
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
                                    // Category picker
                                    Picker("Category", selection: $newGoalCategory) {
                                        ForEach(GoalCategory.allCases) { category in
                                            Text(category.displayName).tag(category)
                                        }
                                    }
                                    .pickerStyle(MenuPickerStyle())
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    // Action buttons
                                    HStack(spacing: 15) {
                                        Button(editingGoal == nil ? "Create" : "Save") {
                                            if !newGoalTitle.isEmpty && !newGoalDescription.isEmpty {
                                                if let editGoal = editingGoal, let idx = goals.firstIndex(where: { $0.id == editGoal.id }) {
                                                    // Edit existing goal
                                                    goals[idx].title = newGoalTitle
                                                    goals[idx].description = newGoalDescription
                                                    goals[idx].category = newGoalCategory
                                                } else {
                                                    // Create new goal at the top
                                                    goals.insert(Goal(title: newGoalTitle, description: newGoalDescription, category: newGoalCategory), at: 0)
                                                }
                                                newGoalTitle = ""
                                                newGoalDescription = ""
                                                newGoalCategory = .selfCare
                                                editingGoal = nil
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
                                                newGoalCategory = .selfCare
                                                editingGoal = nil
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
                                .frame(maxWidth: 600)
                                Spacer()
                            }
                            .padding(.horizontal, 20)
                            .transition(.opacity)
                        }
                        // MARK: - Goals List Section
                        // List of all goals, filtered by category
                        ScrollViewReader { scrollProxy in
                            ScrollView {
                                LazyVStack(spacing: 20) {
                                    ForEach(goals.indices.filter { selectedFilter == nil || goals[$0].category == selectedFilter }, id: \.self) { index in
                                        GoalCard(
                                            goal: $goals[index],
                                            onToggle: {
                                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                                    goals[index].isCompleted.toggle()
                                                }
                                                if goals[index].isCompleted {
                                                    goalJustCompleted = goals[index]
                                                    showSuccessToast = true
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
                                                goalToDelete = goals[index]
                                                showDeleteConfirmation = true
                                            },
                                            onEdit: {
                                                let g = goals[index]
                                                editingGoal = g
                                                newGoalTitle = g.title
                                                newGoalDescription = g.description
                                                newGoalCategory = g.category
                                                withAnimation(.spring()) { showGoalForm = true }
                                            }
                                        )
                                        .id(goals[index].id)
                                    }
                                }
                                .padding(.horizontal, 20)
                                .padding(.bottom, 100)
                            }
                            .onChange(of: goals.count) { oldValue, newValue in
                                // Scroll to top when a new goal is added
                                if let first = goals.first {
                                    withAnimation {
                                        scrollProxy.scrollTo(first.id, anchor: .top)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .alert("Are you sure you want to delete this goal?", isPresented: $showDeleteConfirmation, presenting: goalToDelete) { goal in
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) {
                withAnimation {
                    goals.removeAll { $0.id == goal.id }
                }
            }
        }
        .toast(isShowing: $showSuccessToast, message: "Way to go!")
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                loading = false
                // Add new goal after loading is complete
                if let newGoal = newGoal {
                    goals.insert(newGoal, at: 0)
                }
            }
        }
    }
}

// MARK: - Goal Card Component
// Individual goal card that displays goal info and handles user interactions
struct GoalCard: View {
    @Binding var goal: Goal        // Binding to the goal data
    let onToggle: () -> Void       // Callback for when goal is marked complete
    let onDelete: () -> Void       // Callback for when delete button is tapped
    let onEdit: () -> Void // New edit callback
    
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
                HStack {
                    Text(goal.title)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                        .multilineTextAlignment(.leading)
                        .strikethrough(goal.isCompleted, color: .blue.opacity(0.5))
                    Spacer()
                    // Edit button
                    Button(action: onEdit) {
                        Image(systemName: "pencil")
                            .foregroundColor(.blue.opacity(0.7))
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                Text(goal.description)
                    .font(.subheadline)
                    .foregroundColor(.blue.opacity(0.7))
                    .multilineTextAlignment(.leading)
                    .lineLimit(nil)
                // Category badge
                HStack(spacing: 4) {
                    Image(systemName: goal.category.iconName)
                        .font(.system(size: 14, weight: .bold)) // Larger and more visible icon
                        .foregroundColor(.white)
                    Text(goal.category.displayName)
                        .font(.caption)
                        .foregroundColor(.white) // White font for category
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(goal.category.color.opacity(0.7)) // More vibrant badge background
                .cornerRadius(8)
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
// Custom toast notification for showing success messages
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
// Preview for the GoalsView
#Preview {
    GoalsView(isPresented: .constant(true), newGoal: nil)
}
