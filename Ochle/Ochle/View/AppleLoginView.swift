//
//  AppleLoginView.swift
//  Ochle
//
//  Created by Do Yi Lee on 2022/10/04.
//

import SwiftUI
import AuthenticationServices

final class AppleLoginView: UIViewRepresentable {
    func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
        return ASAuthorizationAppleIDButton()
    }
    
    func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context: Context) {
    }
}
