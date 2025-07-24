//
//  sharedComponents.swift
//  BubbleNavApp_2.0
//
//  Created by DPI Student 141 on 7/16/25.
//

import SwiftUI
//
//  SharedComponents.swift
//  BubbleNavApp_2.0
//
//  Created by DPI Student 141 on 7/16/25.
//

import SwiftUI

// MARK: - View Modifiers
struct darkCardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.black.opacity(0.3))
            )
    }
}

// New: Light card modifier for light, ocean-themed UI
struct lightCardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white.opacity(0.85))
                    .shadow(color: Color.blue.opacity(0.08), radius: 10, x: 0, y: 4)
            )
    }
}

struct lightTextFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .accentColor(.blue)
            .foregroundColor(.blue)
            .bold()
            .padding()
            .font(.title3)
            .background(Color.white.opacity(0.5))
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.blue.opacity(0.3)))
            .frame(width: 350)
    }
}

// New: Light app text modifier for light, ocean-themed UI
struct lightAppTextModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(Color.blue)
            .multilineTextAlignment(.center)
            .font(.title2)
            .bold()
            .padding()
            .fixedSize(horizontal: false, vertical: true)
    }
}

struct appTextModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(Color.blue)
            .multilineTextAlignment(.center)
            .font(.title2)
            .bold()
            .padding()
            .fixedSize(horizontal: false, vertical: true)
    }
}

struct checkInLinkModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.blue)
            .bold()
            .font(.title3)
            .padding(.horizontal, 32)
            .padding(.vertical, 12)
            .background(
                Capsule().stroke(Color.blue.opacity(0.5), lineWidth: 2)
            )
    }
}

struct CompatOnChangeModifier<Value: Equatable>: ViewModifier {
    let value: Value
    let action: (Value) -> Void
    
    func body(content: Content) -> some View {
        if #available(iOS 17, *) {
            content.onChange(of: value) { oldValue, newValue in
                action(newValue)
            }
        } else {
            content.onChange(of: value, perform: action)
        }
    }
}

// MARK: - View Extensions
extension View {
    func compatOnChange<Value: Equatable>(of value: Value, perform action: @escaping (Value) -> Void) -> some View {
        self.modifier(CompatOnChangeModifier(value: value, action: action))
    }
}
