//
//  AffirmationView.swift
//  BubbleNavApp_2.0
//
//  Created by DPI Student 141 on 7/6/25.
//
//  This file implements the ocean-themed Affirmations (Appreciation) page for the app.
//  It includes:
//    - Data models for affirmations and categories
//    - A view model for managing affirmations, filtering, and background animation
//    - The main view for displaying, creating, and using affirmations
//    - Custom UI components for affirmation bubbles and background
//  The design is light, modern, and ocean-inspired, with animated bubbles and a lavender/blue mesh background.
//
//  All major code sections are commented for clarity.
//

import SwiftUI

// MARK: - Data Models
// These structures define the data that our app will work with

/// Represents a single affirmation with all its properties
struct Affirmation: Identifiable, Equatable {
    let id: UUID                    // Unique identifier for each affirmation
    var text: String               // The actual affirmation text
    var category: CategoryKey      // Which category this affirmation belongs to
    var isFavorite: Bool = false   // Whether user marked this as favorite
    var timesUsed: Int = 0        // Track how many times user has used this affirmation
    
    /// Defines the different categories of affirmations available
    enum CategoryKey: String, CaseIterable, Identifiable {
        case selfLove = "self_love"
        case bodyAcceptance = "body_acceptance"
        case strength
        case recovery
        case mindfulness
        case selfWorth = "self_worth"
        
        var id: String { self.rawValue }
        
        /// Human-readable names for each category
        var displayName: String {
            switch self {
            case .selfLove: return "Self Love"
            case .bodyAcceptance: return "Body Acceptance"
            case .strength: return "Strength"
            case .recovery: return "Recovery"
            case .mindfulness: return "Mindfulness"
            case .selfWorth: return "Self Worth"
            }
        }
        
        /// Ocean-themed color scheme for each category
        var color: Color {
            switch self {
            case .selfLove: return Color("categoryPink")
            case .bodyAcceptance: return Color("categoryPurple")
            case .strength: return Color("categoryRed")
            case .recovery: return Color("categoryGreen")
            case .mindfulness: return Color("categoryBlue")
            case .selfWorth: return Color("categoryYellow")
            }
        }
        
        /// Bubble-themed icons for each category
        var iconName: String {
            switch self {
            case .selfLove: return "heart.fill"
            case .bodyAcceptance: return "figure.arms.open"
            case .strength: return "bolt.fill"
            case .recovery: return "leaf.fill"
            case .mindfulness: return "brain.head.profile"
            case .selfWorth: return "star.fill"
            }
        }
    }
}

/// Defines the different ways users can filter affirmations
enum AffirmationFilter: String, CaseIterable, Identifiable {
    case all                        // Show all affirmations
    case favorites                  // Show only favorited affirmations
    case selfLove = "self_love"     // Filter by specific categories
    case bodyAcceptance = "body_acceptance"
    case strength
    case recovery
    case mindfulness
    case selfWorth = "self_worth"
    
    var id: String { rawValue }
    
    /// Human-readable names for filter options
        var displayName: String {
            switch self {
            case .all: return "All Affirmations"
            case .favorites: return "Favorites"
            case .selfLove: return "Self Love"
            case .bodyAcceptance: return "Body Acceptance"
            case .strength: return "Strength"
            case .recovery: return "Recovery"
            case .mindfulness: return "Mindfulness"
            case .selfWorth: return "Self Worth"
            }
        }
    }

// MARK: - Background Bubble Animation
// Reusing your animated background bubble system for the appreciation page

struct AppreciationBubble: Identifiable {
    let id = UUID()
    var xOffset: CGFloat
    var size: CGFloat
    var yOffset: CGFloat = UIScreen.main.bounds.height + 50
    var horizontalDrift: CGFloat
    var opacity: Double
    var duration: Double
}

// MARK: - View Model (Business Logic)
// This class manages all the app's data and business logic

/// Manages the state and operations for the appreciation/affirmations app
@MainActor
class AppreciationViewModel: ObservableObject {
    // Published properties automatically update the UI when changed
    @Published var affirmations: [Affirmation] = []     // All affirmations
    @Published var loading: Bool = true                  // Loading state
    @Published var showForm: Bool = false               // Whether to show create form
    @Published var currentAffirmation: Affirmation? = nil // Currently selected affirmation
    @Published var filter: AffirmationFilter = .all     // Current filter selection
    @Published var backgroundBubbles: [AppreciationBubble] = [] // Background animation bubbles
    @Published var isBackgroundAnimating = false        // Background animation state
    
    // Form state for creating new affirmations
    @Published var formText: String = ""                // Text input for new affirmation
    @Published var formCategory: Affirmation.CategoryKey? = nil // Category selection
    
    // Timer for background bubble generation
    let bubbleTimer = Timer.publish(every: 1.2, on: .main, in: .common).autoconnect()
  
    /// Sample affirmations to populate the app initially
        let sampleAffirmations: [Affirmation] = [
            Affirmation(id: UUID(), text: "I am worthy of love and respect exactly as I am", category: .selfLove),
            Affirmation(id: UUID(), text: "My body is my home and I treat it with kindness", category: .bodyAcceptance),
            Affirmation(id: UUID(), text: "I am stronger than my struggles and capable of healing", category: .strength),
            Affirmation(id: UUID(), text: "Every day I take steps toward wellness and recovery", category: .recovery),
            Affirmation(id: UUID(), text: "I breathe deeply and find peace in this moment", category: .mindfulness),
            Affirmation(id: UUID(), text: "My worth is not determined by my appearance", category: .selfWorth),
        ]
        
    
    /// Initialize the view model and start animations
    init() {
        Task {
            await loadData()
        }
        startBackgroundAnimation()
    }
    
    /// Starts the gentle background animation
    func startBackgroundAnimation() {
        withAnimation(.easeInOut(duration: 8.0).repeatForever(autoreverses: true)) {
            isBackgroundAnimating.toggle()
        }
    }
    
    /// Adds a new bubble to the background animation
    func addBackgroundBubble() {
        guard backgroundBubbles.count < 12 else { return } // Limit bubble count
        
        var newBubble = AppreciationBubble(
            xOffset: CGFloat.random(in: -100...100),
            size: CGFloat.random(in: 15...35),
            horizontalDrift: CGFloat.random(in: -30...30),
            opacity: Double.random(in: 0.2...0.4),
            duration: Double.random(in: 15.0...20.0)
        )
        
        backgroundBubbles.append(newBubble)
        
        // Animate bubble movement
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if let index = self.backgroundBubbles.firstIndex(where: { $0.id == newBubble.id }) {
                withAnimation(.easeOut(duration: newBubble.duration)) {
                    newBubble.yOffset = -UIScreen.main.bounds.height - 100
                    newBubble.xOffset += newBubble.horizontalDrift
                    self.backgroundBubbles[index] = newBubble
                }
            }
        }
        
        // Remove bubble after animation
        DispatchQueue.main.asyncAfter(deadline: .now() + newBubble.duration) {
            if let index = self.backgroundBubbles.firstIndex(where: { $0.id == newBubble.id }) {
                self.backgroundBubbles.remove(at: index)
            }
        }
    }
    
    /// Simulates loading data from a server or database
    func loadData() async {
        loading = true
        // Simulate network delay
        try? await Task.sleep(nanoseconds: 1_500_000_000)
        
        // In a real app, this would fetch from a database or API
        // Always ensure sample affirmations are loaded, but preserve any existing affirmations
        let existingAffirmations = affirmations
            affirmations = sampleAffirmations
        
        // Add back any existing affirmations that aren't already in the sample list
        // Add them at the beginning so they appear first
        for affirmation in existingAffirmations.reversed() {
            if !affirmations.contains(where: { $0.id == affirmation.id }) {
                affirmations.insert(affirmation, at: 0)
            }
        }
        
        loading = false
    }
    
    /// Adds a new affirmation to the existing list
    func addNewAffirmation(_ affirmation: Affirmation) {
        // Only add if it's not already in the list
        if !affirmations.contains(where: { $0.id == affirmation.id }) {
            affirmations.insert(affirmation, at: 0) // Add at the top
        }
    }
    
    /// Creates a new affirmation from the form data
    func createAffirmation() async {
        guard let category = formCategory, !formText.isEmpty else { return }
        
        let newAffirmation = Affirmation(id: UUID(), text: formText, category: category)
        affirmations.append(newAffirmation)
        resetForm()
        showForm = false
    }
    
    /// Clears the form fields
    func resetForm() {
        formText = ""
        formCategory = nil
    }
    
    /// Toggles the favorite status of an affirmation
    func toggleFavorite(affirmation: Affirmation) {
        if let index = affirmations.firstIndex(of: affirmation) {
            affirmations[index].isFavorite.toggle()
        }
    }
    
    /// Marks an affirmation as used and sets it as current
    func useAffirmation(_ affirmation: Affirmation) {
        if let index = affirmations.firstIndex(of: affirmation) {
            affirmations[index].timesUsed += 1
            currentAffirmation = affirmations[index]
        }
    }
    
    /// Adds sample affirmations to the app
    func createSampleAffirmations() async {
        affirmations.append(contentsOf: sampleAffirmations)
    }
    
    /// Returns affirmations filtered based on current filter selection
    var filteredAffirmations: [Affirmation] {
        switch filter {
        case .all:
            return affirmations
        case .favorites:
            return affirmations.filter { $0.isFavorite }
        default:
            return affirmations.filter { $0.category.rawValue == filter.rawValue }
        }
    }
}

// MARK: - Main Themed View
// This is your ocean-themed appreciation page

struct AffirmationView: View {
    @Binding var isPresented: Bool          // Binding from parent view for navigation
    @StateObject private var vm = AppreciationViewModel()  // Our view model
    let newAffirmation: Affirmation? // Optional new affirmation to add from appreciation view
    
    var body: some View {
        NavigationView {
            ZStack {
                // MARK: - Ocean Background
                // Using your animated background system
                lavenderOceanBackgroundView
                
                // MARK: - Main Content
                if vm.loading {
                    // Ocean-themed loading view
                    VStack(spacing: 20) {
                        Image("bubble_icon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .opacity(0.7)
                        
                        Text("Diving into your ocean of appreciation...")
                            .frame(width: 380)
                            .font(.title3)
                            .fontWeight(.medium)
                            .foregroundColor(Color.purple.opacity(0.8))
                            .shadow(color: Color.purple.opacity(0.1), radius: 2)
                        
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: Color.purple.opacity(0.7)))
                            .scaleEffect(1.5)
                    }
                } else {
                    // Main content when data is loaded
                    ScrollView {
                        VStack(spacing: 25) {
                            // Page title with ocean theme
                            lavenderOceanTitleView
                            
                            // Show current affirmation if one is selected
                            if let current = vm.currentAffirmation {
                                currentAffirmationBubbleView(current)
                                    .transition(.scale.combined(with: .opacity))
                            }
                            
                            // Floating action buttons
                            floatingActionsView
                            
                            // Show creation form if user wants to add new affirmation
                            if vm.showForm {
                                bubbleFormView
                                    .transition(.opacity)
                            }
                            
                            // Show empty state or affirmations grid
                            if vm.filteredAffirmations.isEmpty {
                                emptyOceanView
                            } else {
                                affirmationBubblesGrid
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationBarHidden(true)
            .onReceive(vm.bubbleTimer) { _ in
                vm.addBackgroundBubble()
            }
            .overlay(
                // Custom floating back button - only show when not loading
                Group {
                    if !vm.loading {
                        floatingBackButton
                    }
                },
                alignment: .topLeading
            )
            .onAppear {
                // Add new affirmation from appreciation view if provided
                if let newAffirmation = newAffirmation {
                    vm.addNewAffirmation(newAffirmation)
                }
            }
        }
    }
    
    // MARK: - Lavender Ocean Background View
    private var lavenderOceanBackgroundView: some View {
        ZStack {
        
            // Lavender/blue mesh gradient
            MeshGradient(width: 3, height: 3, points: [
                [0.0, 0.0], [0.5, 0.0], [1.0, 0.0],
                [0.0, 0.5], [vm.isBackgroundAnimating ? 0.2 : 0.7, 0.5], [1.0, vm.isBackgroundAnimating ? 0.6 : 0.4],
                [0.0, 1.0], [0.5, 1.0], [1.0, 1.0]
            ], colors: [
                Color(.systemPurple).opacity(0.18), Color("topBlue").opacity(0.18), Color(.systemPurple).opacity(0.18),
                Color(.systemPurple).opacity(0.10), Color("middleBlue").opacity(0.13), Color(.systemPurple).opacity(0.10),
                Color(.systemPurple).opacity(0.08), Color("bottomBlue").opacity(0.10), Color(.systemPurple).opacity(0.08)
            ])
            .ignoresSafeArea()
            
            // Background floating bubbles
            ForEach(vm.backgroundBubbles) { bubble in
                Image("bubble_icon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: bubble.size, height: bubble.size)
                    .opacity(bubble.opacity)
                    .offset(x: bubble.xOffset, y: bubble.yOffset)
                    .animation(.easeOut(duration: bubble.duration), value: bubble.yOffset)
            }
        }
    }
    
    // MARK: - UI Components
    
    /// Ocean-themed title view
    
    private var lavenderOceanTitleView: some View {
        HStack (spacing: 10) {
            
            Spacer()
            
            Text("My Affirmations")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.categoryPurple) // Changed from purple to white
                .shadow(color: Color.purple.opacity(0.08), radius: 3)
            
            Spacer()
        }
        .padding(.top, 40)
    }
    
    
    
    /// Floating back button using your bubble design
    private var floatingBackButton: some View {
        Button(action: {
            isPresented = false
        }) {
            ZStack {
                Image("bubble_icon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40)
                Image(systemName: "house.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.white)
                    .frame(width: 20)
            }

            .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
        }
        .padding(.leading, 20)
        .padding(.top, 50)
    }
    
    /// Current affirmation displayed in a large bubble
    private func currentAffirmationBubbleView(_ affirmation: Affirmation) -> some View {
        VStack(spacing: 15) {
            Spacer()
            // Category icon in a bubble
            ZStack {
                Circle()
                    .fill(affirmation.category.color.opacity(0.7))
                    .frame(width: 60, height: 60)
                    .shadow(color: Color.purple.opacity(0.12), radius: 5)
                
                Image(systemName: affirmation.category.iconName)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
            }
            
            // Affirmation text in a bubble-like container
            Text("\"\(affirmation.text)\"")
                .font(.title3)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
                .foregroundColor(Color.purple.opacity(0.85))
                .padding(20)
                
            
            // Action buttons
            HStack(spacing: 15) {
                
                Button {
                    withAnimation(.spring()) {
                        vm.currentAffirmation = nil
                    }
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "arrow.counterclockwise")
                        Text("Done")
                    }
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(Color.purple.opacity(0.85))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .stroke(Color.purple.opacity(0.25), lineWidth: 1)
                    )
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.7))
                .shadow(color: Color.purple.opacity(0.08), radius: 10)
        )
    }
    
    /// Floating action buttons using your bubble design
    private var floatingActionsView: some View {
        HStack(spacing: 20) {
            // Add affirmation bubble button
            Button {
                withAnimation(.spring()) {
                    vm.showForm.toggle()
                }
            } label: {
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.8))
                        .frame(width: 60, height: 60)
                        .shadow(color: Color.purple.opacity(0.08), radius: 5)
                    
                    Image(systemName: "plus")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(Color.purple.opacity(0.85))
                }
            }
            
            // Sample affirmations button (if empty)
            if vm.affirmations.isEmpty {
                Button {
                    Task {
                        await vm.createSampleAffirmations()
                    }
                } label: {
                    Text("Add Ocean Thoughts")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(Color.purple.opacity(0.85))
                        .padding(.horizontal, 15)
                        .padding(.vertical, 8)
                        .background(
                            Capsule()
                                .stroke(Color.purple.opacity(0.25), lineWidth: 1)
                        )
                }
            }
            
            // Filter picker in bubble style
            Picker("Filter", selection: $vm.filter) {
                ForEach(AffirmationFilter.allCases, id: \.self) { filter in
                    Text(filter.displayName).tag(filter)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .foregroundColor(Color.purple.opacity(0.85)) // Dropdown menu font to purple
            .padding(.horizontal, 15)
            .padding(.vertical, 8)
            .background(
                Capsule()
                    .fill(Color.white.opacity(0.8))
                    .shadow(color: Color.purple.opacity(0.08), radius: 3)
            )
        }
    }
    
    /// Bubble-themed form for creating new affirmations
    private var bubbleFormView: some View {
        VStack(spacing: 20) {
            Text("Create New Affirmation")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.white) // Changed from purple to white
            
            // Text input in bubble style
            TextField("I am ...", text: $vm.formText)
                .textFieldStyle(PlainTextFieldStyle())
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.white.opacity(0.8))
                        .shadow(color: Color.purple.opacity(0.08), radius: 5)
                )
                .foregroundColor(.white)
            
            // Category selection
            Picker("Select Category", selection: $vm.formCategory) {
                Text("Choose a category").tag(Affirmation.CategoryKey?.none)
                ForEach(Affirmation.CategoryKey.allCases) { category in
                    Text(category.displayName).tag(Optional(category))
                }
            }
            .pickerStyle(MenuPickerStyle())
            .foregroundColor(Color.purple.opacity(0.85)) // Dropdown menu font to purple
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.white.opacity(0.8))
                    .shadow(color: Color.purple.opacity(0.08), radius: 5)
            )
            
            // Action buttons
            HStack(spacing: 15) {
                Button("Create") {
                    Task {
                        await vm.createAffirmation()
                    }
                }
                .disabled(vm.formText.isEmpty || vm.formCategory == nil)
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(
                    Capsule()
                        .fill(Color.purple.opacity(0.7))
                        .shadow(color: Color.purple.opacity(0.08), radius: 3)
                )
                
                Button("Cancel") {
                    withAnimation(.spring()) {
                        vm.showForm = false
                        vm.resetForm()
                    }
                }
                .font(.headline)
                .foregroundColor(Color.purple.opacity(0.85))
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(
                    Capsule()
                        .stroke(Color.purple.opacity(0.25), lineWidth: 1)
                )
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.85))
                .shadow(color: Color.purple.opacity(0.08), radius: 10)
        )
    }
    
    /// Grid of affirmation bubbles
    private var affirmationBubblesGrid: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 300), spacing: 20)], spacing: 20) {
            ForEach(vm.filteredAffirmations) { affirmation in
                AffirmationBubbleCard(
                    affirmation: affirmation,
                    toggleFavorite: { vm.toggleFavorite(affirmation: affirmation) },
                    useAffirmation: { vm.useAffirmation(affirmation) }
                )
                .animation(.spring(), value: vm.filteredAffirmations)
            }
        }
    }
    
    /// Empty state view with ocean theme
    private var emptyOceanView: some View {
        VStack(spacing: 20) {
            Image("bubble_icon")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .opacity(0.6)
            
            Text(vm.filter == .all
                 ? "Your ocean is waiting for the first thought..."
                 : "No pearls of wisdom in this category yet...")
                .font(.title3)
                .fontWeight(.medium)
                .foregroundColor(Color.purple.opacity(0.7))
                .multilineTextAlignment(.center)
            
            Button {
                withAnimation(.spring()) {
                    vm.showForm = true
                }
            } label: {
                HStack(spacing: 10) {
                    Image(systemName: "plus")
                    Text("Add Your First Ocean Thought")
                }
                .font(.headline)
                .foregroundColor(Color.purple.opacity(0.85))
                .padding()
                .background(
                    Capsule()
                        .fill(Color.white.opacity(0.8))
                        .shadow(color: Color.purple.opacity(0.08), radius: 5)
                )
            }
        }
        .padding()
    }
}



// MARK: - Preview
#Preview {
    AffirmationView(isPresented: .constant(true), newAffirmation: nil)
}
