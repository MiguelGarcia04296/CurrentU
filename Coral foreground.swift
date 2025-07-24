//
//  Coral foreground.swift
//  BubbleNavApp_2.0
//
//  Created by DPI Student 141 on 7/23/25.
//

import SwiftUI

struct coralForeground: View {
    var body: some View {
            ZStack {
                
                Image("coral")
                    .resizable()
                    .frame(width: 300, height: 400)
                    .aspectRatio(contentMode: .fit)
                    .position(x:100 , y: 475)
                    .opacity(0.45)
                
                Image("coral")
                    .resizable()
                    .frame(width: 300, height: 400)
                    .aspectRatio(contentMode: .fit)
                    .position(x:350 , y: 475)
                    .opacity(0.45)
                
                Image("coral")
                    .resizable()
                    .frame(width: 550, height: 500)
                    .aspectRatio(contentMode: .fit)
                    .position(x:200 , y: 575)
                    .opacity(1)
                
            }
    }
}


#Preview {
    ZStack {
        coralForeground()
    }
}
