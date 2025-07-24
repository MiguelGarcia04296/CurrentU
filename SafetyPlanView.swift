//
//  SafetyPlanView.swift
//  BubbleNavApp_2.0
//
//  Created by DPI Student 141 on 7/6/25.
//
//  This file implements the Safety Plan page, which helps users manage crisis resources and coping strategies.
//  It includes:
//    - Safe person contact management (add, edit, call)
//    - Emergency and support contacts
//    - Coping mechanisms checklist
//    - Personal comfort prompts
//    - Animated ocean background and octopus mascot
//  All major code sections are commented for clarity.
//


// ADD A SAFE PERSON TO CALL

import SwiftUI

// MARK: - Safe Person Model
// This struct represents a contact the user can call for support
struct SafePerson: Identifiable {
    let id: UUID
    var name: String
    var phoneNumber: String

    init(id: UUID = UUID(), name: String, phoneNumber: String) {
        self.id = id
        self.name = name
        self.phoneNumber = phoneNumber
    }
}

struct SafetyPlanView: View {
    @Binding var isPresented: Bool
    
    // User responses from VLowAppreciationView
    let comfortableWhen: String
    let safeWhen: String
    let likeToEat: String
    
    // Loading state
    @State private var loading = true
    
    // Safe Person state variables
    @State private var contacts: [SafePerson] = []
    @State private var showingAddContact = false
    @State private var editingContact: SafePerson? = nil
    @State private var showingCallConfirmation = false
    @State private var selectedContact: SafePerson? = nil
    
    private var floatingBackButton: some View {
        // Custom back button styled as a bubble
        Button(action: {
            isPresented = false
        }) {
            ZStack {
                Image("bubble_icon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50)
                Image(systemName: "house.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.white)
                    .frame(width: 30)
            }

            .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
        }
    }
    
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
            // Background gradient for ocean look
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
            
            if loading {
                // Loading screen
                VStack(spacing: 20) {
                    Image("bubble_icon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .opacity(0.7)
                    
                    Text("Preparing your safety plan...")
                        .frame(width: 380)
                        .font(.title3)
                        .fontWeight(.medium)
                        .foregroundColor(.white.opacity(0.8))
                        .shadow(color: .black.opacity(0.1), radius: 2)
                    
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white.opacity(0.7)))
                        .scaleEffect(1.5)
                }
            } else {
                // Main content
                VStack(spacing: 0) {
                    // Navigation bar with back button and title
                    HStack {
                        floatingBackButton
                        Spacer()
                        Text("Safety Plan")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Spacer()
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                    .padding(.top, 20) // adjust as needed for safe area
                    
                    // Main content scrollable
                    ScrollView {
                        VStack(alignment: .leading, spacing: 24) {
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
                            
                            // Safe People Section
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Safe People")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding(.horizontal)
                                
                                VStack(spacing: 12) {
                                    ForEach(contacts) { contact in
                                        // Each contact row with call and context menu
                                        HStack {
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text(contact.name.isEmpty ? "No Name" : contact.name)
                                                    .foregroundColor(.white)
                                                    .fontWeight(.medium)
                                                Text(contact.phoneNumber)
                                                    .foregroundColor(.white.opacity(0.8))
                                                    .font(.subheadline)
                                            }
                                            Spacer()
                                            Button(action: {
                                                selectedContact = contact
                                                showingCallConfirmation = true
                                            }) {
                                                Image(systemName: "phone.fill")
                                                    .foregroundColor(.green)
                                                    .font(.system(size: 20))
                                            }
                                        }
                                        .padding()
                                        .background(Color.black.opacity(0.3))
                                        .cornerRadius(12)
                                        .contextMenu {
                                            Button("Edit") {
                                                editingContact = contact
                                            }
                                            Button("Delete", role: .destructive) {
                                                contacts.removeAll { $0.id == contact.id }
                                            }
                                        }
                                    }
                                    
                                    if contacts.count < 2 {
                                        // Limit to 2 safe people for simplicity
                                        Button(action: {
                                            showingAddContact = true
                                        }) {
                                            HStack {
                                                Image(systemName: "plus.circle")
                                                Text("Add Safe Person")
                                            }
                                            .foregroundColor(.white)
                                            .padding()
                                            .frame(maxWidth: .infinity)
                                            .background(Color.white.opacity(0.2))
                                            .cornerRadius(12)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                            
                            // Coping mechanisms checklist
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Coping Mechanisms")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding(.horizontal)
                                
                                VStack(spacing: 12) {
                                    ForEach(copingMechanisms, id: \.self) { mechanism in
                                        // Each coping mechanism as a selectable button
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
                            HStack {
                                VStack(alignment: .leading) {
                                    // Comfort, safety, and food prompts
                                    Text("Personal Comfort")
                                        .font(.title3)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                        .padding(.horizontal)
                                    
                                    VStack(alignment: .leading) {
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
                                
                                VStack {
                                        // Animated octopus mascot
                                        Image("octee")
                                            .resizable()
                                            .scaledToFill()
                                            .offset(x: 45, y: octopusOffset)
                                            .frame(width: 45)
                                    }
                                    .onAppear {
                                        // Start octopus bobbing animation
                                        withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                                            octopusOffset = -10
                                        }
                                    }
                            }
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddContact) {
            // Sheet for adding a new safe person
            AddSafePersonView { newContact in
                contacts.append(newContact)
            }
        }
        .sheet(item: $editingContact) { contact in
            // Sheet for editing an existing safe person
            EditSafePersonView(contact: contact) { updated in
                if let index = contacts.firstIndex(where: { $0.id == updated.id }) {
                    contacts[index] = updated
                }
            }
        }
        .alert(isPresented: $showingCallConfirmation) {
            // Alert to confirm calling a contact
            Alert(
                title: Text("Call \(selectedContact?.name.isEmpty == false ? selectedContact!.name: "this contact")?"),
                primaryButton: .default(Text("Call")) {
                    if let number = selectedContact?.phoneNumber,
                       let url = URL(string: "tel://\(number)"),
                       UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url)
                    }
                },
                secondaryButton: .cancel()
            )
        }
        .onAppear {
            // Simulate loading delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                loading = false
            }
        }
    }
}

// MARK: - Add Safe Person Sheet
// This sheet allows the user to add a new safe person contact
struct AddSafePersonView: View {
    @Environment(\.dismiss) var dismiss
    @State private var name = ""
    @State private var phone = ""

    var onSave: (SafePerson) -> Void

    var body: some View {
        ZStack {
            // Background gradient matching SafetyPlanView
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
            
            VStack(spacing: 30) {
                // Header with Cancel/Save and title
                HStack {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                    .font(.headline)
                    
                    Spacer()
                    
                    Text("Add Safe Person")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button("Save") {
                        if !phone.trimmingCharacters(in: .whitespaces).isEmpty {
                            let contact = SafePerson(name: name, phoneNumber: phone)
                            onSave(contact)
                            dismiss()
                        }
                    }
                    .foregroundColor(.white)
                    .font(.headline)
                    .disabled(phone.trimmingCharacters(in: .whitespaces).isEmpty)
                }
                .padding(.horizontal)
                .padding(.top, 20)
                
                // Form fields for name and phone number
                VStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Name (optional)")
                            .foregroundColor(.white.opacity(0.8))
                            .font(.subheadline)
                        
                        TextField("Enter name", text: $name)
                            .textFieldStyle(PlainTextFieldStyle())
                            .padding()
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(12)
                            .foregroundColor(.white)
                            .accentColor(.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
                            )
                            .onAppear {
                                UITextField.appearance().placeholder = "Enter name"
                                UITextField.appearance().attributedPlaceholder = NSAttributedString(
                                    string: "Enter name",
                                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.6)]
                                )
                            }
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Phone Number")
                            .foregroundColor(.white.opacity(0.8))
                            .font(.subheadline)
                        
                        TextField("Enter phone number", text: $phone)
                            .textFieldStyle(PlainTextFieldStyle())
                            .keyboardType(.numberPad)
                            .padding()
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(12)
                            .foregroundColor(.white)
                            .accentColor(.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
                            )
                            .onAppear {
                                UITextField.appearance().placeholder = "Enter phone number"
                                UITextField.appearance().attributedPlaceholder = NSAttributedString(
                                    string: "Enter phone number",
                                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.6)]
                                )
                            }
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
        }
    }
}

// MARK: - Edit Safe Person Sheet
// This sheet allows the user to edit an existing safe person contact
struct EditSafePersonView: View {
    @Environment(\.dismiss) var dismiss
    @State private var name: String
    @State private var phone: String

    var contact: SafePerson
    var onSave: (SafePerson) -> Void

    init(contact: SafePerson, onSave: @escaping (SafePerson) -> Void) {
        self.contact = contact
        self.onSave = onSave
        _name = State(initialValue: contact.name)
        _phone = State(initialValue: contact.phoneNumber)
    }

    var body: some View {
        ZStack {
            // Background gradient matching SafetyPlanView
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
            
            VStack(spacing: 30) {
                // Header with Cancel/Save and title
                HStack {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                    .font(.headline)
                    
                    Spacer()
                    
                    Text("Edit Contact")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button("Save") {
                        let updated = SafePerson(id: contact.id, name: name, phoneNumber: phone)
                        onSave(updated)
                        dismiss()
                    }
                    .foregroundColor(.white)
                    .font(.headline)
                    .disabled(phone.trimmingCharacters(in: .whitespaces).isEmpty)
                }
                .padding(.horizontal)
                .padding(.top, 20)
                
                // Form fields for name and phone number
                VStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Name (optional)")
                            .foregroundColor(.white.opacity(0.8))
                            .font(.subheadline)
                        
                        TextField("Enter name", text: $name)
                            .textFieldStyle(PlainTextFieldStyle())
                            .padding()
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(12)
                            .foregroundColor(.white)
                            .accentColor(.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
                            )
                            .onAppear {
                                UITextField.appearance().placeholder = "Enter name"
                                UITextField.appearance().attributedPlaceholder = NSAttributedString(
                                    string: "Enter name",
                                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.6)]
                                )
                            }
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Phone Number")
                            .foregroundColor(.white.opacity(0.8))
                            .font(.subheadline)
                        
                        TextField("Enter phone number", text: $phone)
                            .textFieldStyle(PlainTextFieldStyle())
                            .keyboardType(.phonePad)
                            .padding()
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(12)
                            .foregroundColor(.white)
                            .accentColor(.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
                            )
                            .onAppear {
                                UITextField.appearance().placeholder = "Enter phone number"
                                UITextField.appearance().attributedPlaceholder = NSAttributedString(
                                    string: "Enter phone number",
                                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.6)]
                                )
                            }
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
        }
    }
}

// Preview for development
#Preview {
    SafetyPlanView(isPresented: .constant(true))
}
