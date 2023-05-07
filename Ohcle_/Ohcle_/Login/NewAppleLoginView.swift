//
//  NewAppleLoginView.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2023/05/07.
//

import SwiftUI
import AuthenticationServices

struct ContentView2: View {
    @State private var isSignInWithApplePresented = false
    
    var body: some View {
        VStack {
            // Other content of your view
            Button("asdf") {
                self.isSignInWithApplePresented = true
            }
        }
        .sheet(isPresented: $isSignInWithApplePresented) {
            NewAppleLoginView()
        }
    }
}

struct NewAppleLoginView: View {
    @AppStorage("isLoggedIn") private var isLoggedIn : Bool = UserDefaults.standard.bool(forKey: "isLoggedIn")
    
    var body: some View {
        SignInWithAppleButton(
            onRequest: { request in
                request.requestedScopes = [.fullName, .email]
            },
            onCompletion: { result in
                switch result {
                case .success(let authResult):
                    handleAuthorizationSuccess(authResult)
                    self.isLoggedIn = true
                case .failure(let error):
                    handleAuthorizationFailure(error)
                }
            }
        )
        .frame(width: 280, height: 45)
    }
    
    func handleAuthorizationSuccess(_ authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let userID = appleIDCredential.user
            print("User ID: \(userID)")
            
            if let fullName = appleIDCredential.fullName {
                let firstName = fullName.givenName ?? ""
                let lastName = fullName.familyName ?? ""
                print("Full Name: \(firstName) \(lastName)")
            }
            
            if let email = appleIDCredential.email {
                print("Email: \(email)")
            }
        }
    }
    
    func handleAuthorizationFailure(_ error: Error) {
        print("Sign In with Apple Error: \(error.localizedDescription)")
    }
}

