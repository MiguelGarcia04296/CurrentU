//
//  ThoughtReframeView.swift
//  BubbleNavApp_2.0
//
//  Created by DPI Student 141 on 7/6/25.
//
import SwiftUI

struct ThoughtReframeView: View {
    @Binding var isPresented: Bool
    
    @State private var userThought: String = ""
    @State private var selectedEmotion: String = ""
    
    // ADDED: multiple emotions tracking and input text field
    @State private var selectedEmotions: Set<String> = []
    @State private var emotionInput: String = ""
    
    @State private var friendResponse: String = ""
    @State private var showReframe: Bool = false
    struct SavedReframe: Identifiable, Equatable {
        let id = UUID()
        let text: String
        let date: Date
    }
    @State private var savedReframes: [SavedReframe] = []
    @State private var showDeleteConfirmation: SavedReframe? = nil
    @State private var showGrounding: Bool = false
    
    let commonThoughts = [
        "I'm uncomfortable in my body",
        "I ate too much",
        "I feel gross",
        "My clothes don't fit right",
        "Why do I look like this?",
        "I don't look like I used to",
        "I wish I could disappear",
        "I look different from everyone else",
        "I hate how I look in photos",
        "I hate how I look in the mirror",
        "People are judging my body",
        "I should've skipped that meal"
    ]

    let emotions = [
        "Sad", "Angry", "Anxious", "Lonely", "Insecure",
        "Overwhelmed", "Embarrassed", "Stuck", "Ashamed", "Tired", "Guilty", "Frustrated"
    ]

    let groundingActivities = [
        "Stretch to your favorite song",
        "Write yourself a letter",
        "Drink water",
        "Go for a walk outside",
        "Call or text a friend"
    ]

    func convertToFirstPerson(_ text: String) -> String {
        var result = text

        // 1. Replace contractions first — apostrophes break word boundaries so no \b here.
        // Use case-insensitive matching
        let contractionReplacements: [String: String] = [
            "(?i)you're": "I'm",
            "(?i)you’re": "I'm",  // smart apostrophe variant
            "(?i)you'd": "I'd",
            "(?i)you’d": "I'd",
            "(?i)you've": "I've",
            "(?i)you’ve": "I've",
            "(?i)you'll": "I'll",
            "(?i)you’ll": "I'll"
        ]

        for (pattern, replacement) in contractionReplacements {
            result = result.replacingOccurrences(of: pattern, with: replacement, options: [.regularExpression])
        }

        // 2. Replace longer phrases with word boundaries.
        let phraseReplacements: [String: String] = [
            "(?i)\\bi love you\\b": "I love myself",
            "(?i)\\bproud of you\\b": "proud of myself",
            "(?i)\\bremind you\\b": "remind myself",
            "(?i)\\bcare about you\\b": "care about myself",
            "(?i)\\bfor you\\b": "for myself",
            "(?i)\\byou are beautiful\\b": "I am beautiful",
            "(?i)\\byou are worthy\\b": "I am worthy",
            "(?i)\\byou are enough\\b": "I am enough",
            "(?i)\\byou are safe\\b": "I am safe",
            "(?i)\\byou are loved\\b": "I am loved",
            "(?i)\\byou are strong\\b": "I am strong",
            "(?i)\\byou matter\\b": "I matter",
            "(?i)\\byou belong\\b": "I belong",
            "(?i)\\byou got this\\b": "I got this",
            "(?i)(support|love|remind|trust|forgive|care about|help|thank|appreciate) you\\b": "$1 myself"
        ]

        for (pattern, replacement) in phraseReplacements {
            result = result.replacingOccurrences(of: pattern, with: replacement, options: [.regularExpression])
        }

        // 3. Replace standalone pronouns — exclude 'you' followed by apostrophe to avoid contractions.
        let pronounReplacements: [String: String] = [
            "\\byourself\\b": "myself",
            "\\bYourself\\b": "Myself",
            "\\byour\\b": "my",
            "\\bYour\\b": "My",
            "\\byours\\b": "mine",
            "\\bYours\\b": "Mine",
            // Negative lookahead (?!['’]) prevents matching 'you' inside contractions like "you're"
            "\\byou(?!['’])\\b": "I",
            "\\bYou(?!['’])\\b": "I"
        ]

        for (pattern, replacement) in pronounReplacements {
            result = result.replacingOccurrences(of: pattern, with: replacement, options: [.regularExpression])
        }

        // Capitalize standalone 'i'
        if let regex = try? NSRegularExpression(pattern: "\\bi\\b", options: []) {
            let range = NSRange(result.startIndex..<result.endIndex, in: result)
            result = regex.stringByReplacingMatches(in: result, options: [], range: range, withTemplate: "I")
        }

        // Capitalize first letter of the string
        if let first = result.first {
            result.replaceSubrange(result.startIndex...result.startIndex, with: String(first).uppercased())
        }

        // Remove trailing "it" after "need" or "need to"
        result = result.replacingOccurrences(of: "(?i)(need (it|to it))\\b", with: "need", options: .regularExpression)

        return result
    }

    var reframe: String {
        guard !userThought.isEmpty, !friendResponse.isEmpty else { return "" }
        let personalized = convertToFirstPerson(friendResponse)
        
        // Use all selectedEmotions if not empty, else fallback to selectedEmotion
        let emotionsList: String
        if !selectedEmotions.isEmpty {
            let sortedEmotions = selectedEmotions.sorted().map { $0.lowercased() }
            if sortedEmotions.count == 1 {
                emotionsList = sortedEmotions[0]
            } else if sortedEmotions.count == 2 {
                emotionsList = "\(sortedEmotions[0]) and \(sortedEmotions[1])"
            } else {
                // More than 2 emotions: join with commas, add "and" before last
                let allButLast = sortedEmotions.dropLast().joined(separator: ", ")
                let last = sortedEmotions.last!
                emotionsList = "\(allButLast), and \(last)"
            }
        } else if !selectedEmotion.isEmpty {
            emotionsList = selectedEmotion.lowercased()
        } else {
            return "" // no emotions selected so no reframe
        }

        return "I feel \(emotionsList), but this feeling doesn't define me. \(personalized)"
    }

    var body: some View {
        BackgroundContainer {
            ZStack(alignment: .top) {
                // Add green overlay blend mode over the background for a watery effect
                Color.green.opacity(0.90)
                    .ignoresSafeArea()
                    .blendMode(.overlay)
                VStack(spacing: 0) {
                    // MARK: - Top Navigation Buttons
                    HStack {
                        // Bubble-style back button (top left)
                        Button(action: { isPresented = false }) {
                            ZStack {
                                Image("bubble_icon")
                                    .resizable()
                                    .frame(width: 44, height: 44)
                                Image(systemName: "arrowshape.backward.fill")
                                    .foregroundColor(.white)
                                    .font(.system(size: 24))
                            }
                        }
                        .padding(.leading, 12)
                        Spacer()
                        // Bubble-style home button (top right)
                        Button(action: { isPresented = false }) {
                            ZStack {
                                Image("bubble_icon")
                                    .resizable()
                                    .frame(width: 44, height: 44)
                                Image(systemName: "house.fill")
                                    .foregroundColor(.white)
                                    .font(.system(size: 20))
                            }
                        }
                        .padding(.trailing, 12)
                    }
                    .padding(.top, 36)
                    // MARK: - Main Content Card (compact, semi-transparent)
                    ScrollView {
                        VStack(alignment: .leading, spacing: 14) {
                            // MARK: - User Thought Input
                            Group {
                                Text("What's on your mind?")
                                    .font(.headline)
                                    .foregroundColor(Color("categoryGreen"))
                                    .padding(.bottom, 2)
                                // Opaque, light green text editor for user thought
                                TextEditor(text: $userThought)
                                    .frame(height: 70)
                                    .font(.body)
                                    .background(Color("categoryGreen").opacity(0.18))
                                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color("categoryGreen").opacity(0.5)))
                                    .cornerRadius(12)
                                    .padding(.bottom, 2)
                                // Common thoughts as quick-pick buttons
                                LazyVGrid(columns: Array(repeating: GridItem(.flexible(minimum: 100)), count: 2), spacing: 6) {
                                    ForEach(commonThoughts, id: \.self) { thought in
                                        Button(action: { userThought = thought }) {
                                            Text(thought)
                                                .multilineTextAlignment(.center)
                                                .frame(maxWidth: .infinity, minHeight: 36)
                                                .font(.subheadline)
                                                .bold()
                                                .padding(6)
                                                .background(Color("categoryGreen").opacity(0.30)) // Opaque, lighter green
                                                .foregroundColor(.white)
                                                .cornerRadius(10)
                                        }
                                    }
                                }
                            }
                            // MARK: - Emotions Input
                            Group {
                                Text("How do you feel?")
                                    .font(.headline)
                                    .foregroundColor(Color("categoryGreen"))
                                    .padding(.bottom, 2)
                                // Opaque, light green text field for emotions
                                TextField("List emotions", text: $emotionInput, onCommit: {
                                    let inputEmotions = emotionInput
                                        .split(separator: ",")
                                        .map { $0.trimmingCharacters(in: .whitespacesAndNewlines).capitalized }
                                        .filter { !$0.isEmpty }
                                    selectedEmotions = Set(inputEmotions)
                                    if selectedEmotions.count == 1 {
                                        selectedEmotion = selectedEmotions.first ?? ""
                                    } else {
                                        selectedEmotion = ""
                                    }
                                    emotionInput = selectedEmotions.sorted().joined(separator: ", ")
                                })
                                .font(.body)
                                .background(Color("categoryGreen").opacity(0.18))
                                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color("categoryGreen").opacity(0.5)))
                                .cornerRadius(12)
                                .padding(.bottom, 2)
                                // Emotions as quick-pick buttons
                                LazyVGrid(columns: Array(repeating: GridItem(.flexible(minimum: 80)), count: 3), spacing: 6) {
                                    ForEach(emotions, id: \.self) { emotion in
                                        Button(action: {
                                            if selectedEmotions.contains(emotion) {
                                                selectedEmotions.remove(emotion)
                                            } else {
                                                selectedEmotions.insert(emotion)
                                            }
                                            if selectedEmotions.count == 1 {
                                                selectedEmotion = selectedEmotions.first ?? ""
                                            } else {
                                                selectedEmotion = ""
                                            }
                                            emotionInput = selectedEmotions.sorted().joined(separator: ", ")
                                        }) {
                                            Text(emotion)
                                                .frame(maxWidth: .infinity, minHeight: 28)
                                                .font(.subheadline)
                                                .bold()
                                                .padding(5)
                                                .background(selectedEmotions.contains(emotion) ? Color("categoryGreen").opacity(0.40) : Color("categoryGreen").opacity(0.30)) // Opaque, lighter green
                                                .foregroundColor(.white)
                                                .cornerRadius(10)
                                        }
                                    }
                                }
                            }
                            // MARK: - Friend Response Input
                            Group {
                                Text("What would you say to a friend who was feeling like this?")
                                    .font(.headline)
                                    .foregroundColor(Color("categoryGreen"))
                                    .padding(.bottom, 2)
                                // Opaque, light green text editor for friend response
                                TextEditor(text: $friendResponse)
                                    .frame(height: 70)
                                    .font(.body)
                                    .background(Color("categoryGreen").opacity(0.18))
                                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color("categoryGreen").opacity(0.5)))
                                    .cornerRadius(12)
                            }
                            // MARK: - Reframe Output and Save Button
                            if showReframe {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Your Reframe:")
                                        .font(.headline)
                                        .foregroundColor(Color("categoryGreen"))
                                    Text(reframe)
                                        .italic()
                                        .font(.subheadline)
                                        .padding(8)
                                        .background(Color("categoryGreen").opacity(0.10))
                                        .cornerRadius(10)
                                    // Opaque, contrasting green save button
                                    Button("Save") {
                                        if !savedReframes.contains(where: { $0.text == reframe }) {
                                            savedReframes.append(SavedReframe(text: reframe, date: Date()))
                                        }
                                    }
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 7)
                                    .background(Color("categoryGreen").opacity(0.85))
                                    .cornerRadius(12)
                                }
                            } else {
                                // Opaque, contrasting green reframe button
                                Button("Reframe") {
                                    showReframe = true
                                }
                                .font(.subheadline)
                                .foregroundColor(.white)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 7)
                                .background(Color("categoryGreen").opacity(0.85))
                                .cornerRadius(12)
                            }
                            // MARK: - Ground Myself Button
                            if showReframe {
                                Button("Ground Myself") {
                                    showGrounding.toggle()
                                }
                                .font(.subheadline)
                                .foregroundColor(.white)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 7)
                                .background(Color("categoryGreen").opacity(0.85))
                                .cornerRadius(12)
                            }
                            // MARK: - Grounding Activities
                            if showGrounding {
                                VStack(alignment: .leading, spacing: 6) {
                                    Text("Try one of these:")
                                        .font(.subheadline)
                                        .foregroundColor(Color("categoryGreen"))
                                    ForEach(groundingActivities, id: \.self) { activity in
                                        Text("• " + activity)
                                            .font(.caption2)
                                    }
                                }
                            }
                            // MARK: - Saved Reframes List
                            if !savedReframes.isEmpty {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("My Reframed Thoughts")
                                        .font(.headline)
                                        .foregroundColor(Color("categoryGreen"))
                                    ForEach(savedReframes) { item in
                                        HStack {
                                            VStack(alignment: .leading, spacing: 2) {
                                                Text(item.text)
                                                    .font(.caption2)
                                                    .padding(4)
                                                    .background(Color("categoryGreen").opacity(0.08))
                                                    .cornerRadius(8)
                                                Text(item.date.formatted(date: .abbreviated, time: .shortened))
                                                    .font(.caption2)
                                                    .foregroundColor(.gray)
                                            }
                                            Spacer()
                                            // Opaque, red delete button
                                            Button(action: { showDeleteConfirmation = item }) {
                                                Image(systemName: "trash")
                                                    .foregroundColor(.white)
                                                    .padding(6)
                                                    .background(Color.red.opacity(0.85))
                                                    .cornerRadius(8)
                                            }
                                        }
                                    }
                                }
                            }
                            // MARK: - Safety Plan Button
                            Button("Safety Plan") {
                                //link to safety plan
                            }
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 7)
                            .background(Color("categoryGreen").opacity(0.85))
                            .cornerRadius(12)
                            .padding(.top, 2)
                        }
                        .padding(14)
                        .background(
                            RoundedRectangle(cornerRadius: 18)
                                .fill(Color.white.opacity(0.65)) // More transparent card
                                .shadow(color: Color.green.opacity(0.10), radius: 8, x: 0, y: 4)
                        )
                        .cornerRadius(18)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 8)
                    }
                }
                // MARK: - Delete Confirmation Popup
                ZStack {
                    if let itemToDelete = showDeleteConfirmation {
                        Color.black.opacity(0.4)
                            .ignoresSafeArea()
                        VStack(spacing: 12) {
                            Text("Are you sure you want to delete this reframe?")
                                .multilineTextAlignment(.center)
                                .font(.headline)
                                .padding(.horizontal)
                            Text("\"\(itemToDelete.text)\"")
                                .italic()
                                .multilineTextAlignment(.center)
                                .font(.subheadline)
                                .padding(.horizontal)
                            HStack(spacing: 14) {
                                Button("Cancel") {
                                    showDeleteConfirmation = nil
                                }
                                .padding(7)
                                .frame(maxWidth: .infinity)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(8)
                                Button("Delete") {
                                    savedReframes.removeAll { $0.id == itemToDelete.id }
                                    showDeleteConfirmation = nil
                                }
                                .padding(7)
                                .frame(maxWidth: .infinity)
                                .background(Color.red.opacity(0.85))
                                .foregroundColor(.white)
                                .cornerRadius(8)
                            }
                            .padding(.horizontal)
                        }
                        .padding(10)
                        .background(Color.white)
                        .cornerRadius(14)
                        .shadow(radius: 8)
                        .padding(30)
                    }
                }
            }
        }
    }
}

//preview for dev
#Preview {
    ThoughtReframeView(isPresented: .constant(true))
}
