//
//  ModerateAppreciationView.swift
//  BubbleNavApp_2.0
//
//  Created by DPI Student 141 on 7/16/25.
//

import SwiftUI

struct ModerateAppreciationView: View {
    @Binding var isPresented: Bool
    @Environment(\.dismiss) var dismiss
    @State private var affirmationText = ""
    @State private var selectedCategory: Affirmation.CategoryKey = .selfLove
    
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
                                .foregroundColor(.white)
                                .bold()
                                .font(.system(size: 30))
                        }
                    }
                    Spacer()
                }
                .padding(.top, 60)
                .padding(.leading, 20)
                
                VStack(spacing: 20) {
                    Text("Create an affirmation!")
                        .modifier(appTextModifier())
                    
                    // Affirmation Text Input
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Affirmation")
                            .font(.headline)
                            .foregroundColor(.blue)
                        TextField("I am...", text: $affirmationText)
                            .modifier(lightTextFieldModifier())
                    }
                    
                    // Category Selection
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Category")
                            .font(.headline)
                            .foregroundColor(.blue)
                        Picker("Category", selection: $selectedCategory) {
                            ForEach(Affirmation.CategoryKey.allCases) { category in
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
                
                NavigationLink(destination: DoneModerateAppreciation(isPresented: $isPresented, affirmationText: affirmationText, affirmationCategory: selectedCategory)) {
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
                .disabled(affirmationText.isEmpty)
                .opacity(affirmationText.isEmpty ? 0.5 : 1.0)
                .padding(.top, 10)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#if DEBUG
struct ModerateAppreciationView_Previews: PreviewProvider {
    static var previews: some View {
        ModerateAppreciationView(isPresented: .constant(true))
    }
}
#endif

