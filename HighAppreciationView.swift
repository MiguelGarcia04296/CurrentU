//
//  HighAppreciationView.swift
//  BubbleNavApp_2.0
//
//  Created by DPI Student 141 on 7/16/25.
//

import SwiftUI

// MARK: - Task Views
struct HighAppreciationView: View {
    @Binding var isPresented: Bool
    @Environment(\.dismiss) var dismiss
    @State private var goalTitle = ""
    @State private var goalDescription = ""
    @State private var selectedCategory: GoalCategory = .selfCare
    @State private var showGoalsView = false
    
    var body: some View {
        BackgroundContainer {
            VStack {
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        ZStack {
                            Image("bubble_icon")
                                .resizable()
                                .frame(width: 50, height: 50)
                            Image(systemName: "arrowshape.backward.fill")
                                .bold()
                                .foregroundColor(.white)
                                .font(.system(size: 30))
                        }
                    }
                    Spacer()
                }
                .padding(.top, 60)
                .padding(.leading, 20)
                
                VStack(spacing: 20) {
                    Text("Create a Self-Care or Nutrition Goal!")
                        .modifier(appTextModifier())
                    
                    // Goal Title Input
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Goal Title")
                            .font(.headline)
                            .foregroundColor(.blue)
                        TextField("Enter goal title...", text: $goalTitle)
                            .modifier(lightTextFieldModifier())
                    }
                    
                    // Goal Description Input
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Goal Description")
                            .font(.headline)
                            .foregroundColor(.blue)
                        TextField("Enter goal description...", text: $goalDescription)
                            .modifier(lightTextFieldModifier())
                    }
                    
                    // Category Selection
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Category")
                            .font(.headline)
                            .foregroundColor(.blue)
                        Picker("Category", selection: $selectedCategory) {
                            ForEach(GoalCategory.allCases) { category in
                                Text(category.displayName).tag(category)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.white.opacity(0.8))
                                .shadow(color: .blue.opacity(0.08), radius: 5)
                        )
                        .foregroundColor(.blue)
                    }
                }
                .modifier(lightCardModifier())
                
                NavigationLink(destination: DoneHighAppreciation(isPresented: $isPresented, goalTitle: goalTitle, goalDescription: goalDescription, goalCategory: selectedCategory)) {
                    ZStack {
                        Image("bubble_icon")
                            .resizable()
                            .frame(width: 50, height: 50)
                        Image(systemName: "arrowshape.right.fill")
                            .foregroundColor(.white)
                            .bold()
                            .font(.system(size: 30))
                    }
                }
                .disabled(goalTitle.isEmpty || goalDescription.isEmpty)
                .opacity(goalTitle.isEmpty || goalDescription.isEmpty ? 0.5 : 1.0)
                .padding(.top, 10)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#if DEBUG
struct HighAppreciationView_Previews: PreviewProvider {
    static var previews: some View {
        HighAppreciationView(isPresented: .constant(true))
    }
}
#endif


