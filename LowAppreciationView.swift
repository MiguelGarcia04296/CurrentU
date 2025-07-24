//
//  LowAppreciationView.swift
//  BubbleNavApp_2.0
//
//  Created by DPI Student 141 on 7/16/25.
//

import SwiftUI

struct LowAppreciationView: View {
    @Binding var isPresented: Bool
    @Environment(\.dismiss) var dismiss
    @State private var externalTrait = ""
    @State private var internalTraits = ""
    
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
                                .font(.system(size: 30))
                        }
                    }
                    Spacer()
                }
                .padding(.top, 60)
                .padding(.leading, 20)
                
                VStack {
                    Text("What do you like about yourself?")
                        .modifier(appTextModifier())
                    
                    Text("I Like My.....")
                        .modifier(appTextModifier())
                    
                    TextField("Pick 1 External Trait", text: $externalTrait)
                        .modifier(lightTextFieldModifier())
                    
                    TextField("Pick 3 Internal Traits", text: $internalTraits)
                        .modifier(lightTextFieldModifier())
                }
                .modifier(lightCardModifier())
                
                NavigationLink(destination: DoneLowAppreciation(isPresented: $isPresented)) {
                    ZStack {
                        Image("bubble_icon")
                            .resizable()
                            .frame(width: 50, height: 50)
                        Image(systemName: "arrowshape.right.fill")
                            .foregroundColor(.white)
                            .font(.system(size: 25))
                    }
                }
                .padding(.top, 10)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#if DEBUG
struct LowAppreciationView_Previews: PreviewProvider {
    static var previews: some View {
        LowAppreciationView(isPresented: .constant(true))
    }
}
#endif

