//
//  VLowAppreciationView.swift
//  BubbleNavApp_2.0
//
//  Created by DPI Student 141 on 7/16/25.
//

import SwiftUI
struct VLowAppreciationView: View {
    @Binding var isPresented: Bool
    @Environment(\.dismiss) var dismiss
    @State private var comfortableWhen = ""
    @State private var safeWhen = ""
    @State private var likeToEat = ""
    
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
                                .font(.system(size: 20))
                        }
                    }
                    Spacer()
                }
                .padding(.top, 60)
                .padding(.leading, 20)
                
                VStack {
                    Text("Understanding your needs")
                        .modifier(appTextModifier())
                    
                    Text("I'm comfortable when.....")
                        .modifier(appTextModifier())
                    
                    TextField("Write here", text: $comfortableWhen)
                        .modifier(lightTextFieldModifier())
                    
                    Text("I feel safe when.....")
                        .modifier(appTextModifier())
                    
                    TextField("Write here", text: $safeWhen)
                        .modifier(lightTextFieldModifier())
                    
                    Text("I like to eat.....")
                        .modifier(appTextModifier())
                    
                    TextField("Write here", text: $likeToEat)
                        .modifier(lightTextFieldModifier())
                }
                .modifier(lightCardModifier())
                
                NavigationLink(destination: DoneVLowAppreciation(
                    isPresented: $isPresented,
                    comfortableWhen: comfortableWhen,
                    safeWhen: safeWhen,
                    likeToEat: likeToEat
                )) {
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
struct VLowAppreciationView_Previews: PreviewProvider {
    static var previews: some View {
        VLowAppreciationView(isPresented: .constant(true))
    }
}
#endif


