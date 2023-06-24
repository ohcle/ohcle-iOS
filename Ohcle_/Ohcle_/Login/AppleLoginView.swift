//
//  AppleLoginView.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2022/11/24.
//

import SwiftUI
import _AuthenticationServices_SwiftUI

struct AppleLoginView: View {
    @State private var isLoginError: Bool = false
    
    var body: some View {
        if #available(iOS 15.0, *) {
            SignInWithAppleButton(.signUp) { request in
                request.requestedScopes = [.email, .fullName]
            } onCompletion: { result in
                Task {
                    await LoginManager.shared.singInAppleAccount(result)
                }
            }
            .signInWithAppleButtonStyle(.black)
            .alert("Apple Login Error", isPresented: $isLoginError) {
                Text("Apple Login Error")
            }
            .frame(height: 55)
        } else {
            // Fallback on earlier versions
        }
    }
}

struct AppleLoginView_Previews: PreviewProvider {
    static var previews: some View {
        AppleLoginView()
    }
}
