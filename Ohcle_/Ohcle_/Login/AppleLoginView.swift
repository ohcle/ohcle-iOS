//
//  AppleLoginView.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2022/11/24.
//

import SwiftUI
import _AuthenticationServices_SwiftUI

extension Notification.Name {
    static let appleLoginError = Notification.Name("appleLoginError")
}

struct AppleLoginView: View {
    typealias AppleLoginReslutType = [String: Any]
    
    @EnvironmentObject var loginSetting: LoginSetting
    @State private var isLoginError: Bool = false
    
    @AppStorage("isLoggedIn") private var isLoggedIn : Bool = UserDefaults.standard.bool(forKey: "isLoggedIn")
    @AppStorage("ohcleToken") private var ohcleToken = ""
    
    var body: some View {
        if #available(iOS 15.0, *) {
            SignInWithAppleButton(.signUp) { request in
                request.requestedScopes = [.email, .fullName]
            } onCompletion: { result in
                Task {
                    await filterAppleLoginResult(result)
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
    
    private func requestLogin(appleUserID: String,
                                  firstName: String,
                                  lastName: String,
                                  email: String,
                                  gender: String? = nil) async throws {
        let url = getAccessTokenURL(.appleLogin)
        var request = try URLRequest(url: url, method: .post)
        let parameter = ["id": appleUserID,
                    "first_name": firstName,
                    "last_name": lastName,
                    "email": email,
                    "gender": gender]
        
        let httpBody = try JSONSerialization.data(withJSONObject: parameter, options: [])
        request.httpBody = httpBody
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (loginResult, response) = try await URLSession.shared.data(for: request)
        
        if let response = response as? HTTPURLResponse,
           response.statusCode != 200 {
            print("reponse Code is :\(response.statusCode)")
        }
        
        isValidLoginResult(loginResult)
    }
    
    private func isValidLoginResult(_ data: Data) {
        do {
            let decodedData = try JSONDecoder().decode(AppleLoginResultModel.self, from: data)
            UserTokenManager.shared.save(token: decodedData.token,
                                         account: .apple,
                                         service: .login)
        } catch {
            let errorMessage = error.localizedDescription
            NotificationCenter.default
                .post(name: .kakaoLoginError, object: errorMessage)
        }
    }
    
    private func filterAppleLoginResult(_ result: Result<ASAuthorization, Error>) async {
        switch result {
        case .success(let auth):
            if let credential = auth.credential as? ASAuthorizationAppleIDCredential {
                let userID = credential.user
                
                let firstName = credential.fullName?.familyName ?? ""
                let lastName = credential.fullName?.givenName ?? ""
                let email = credential.email ?? "ohcle@gmail.com"
                
                do {
                    try await requestLogin(appleUserID: userID,
                                     firstName: firstName,
                                     lastName: lastName,
                                     email: email)
                    self.isLoggedIn = true
                } catch {
                   print(error)
                }
            }

        case .failure(let error):
            self.isLoggedIn = false
            print("Apple Login Error. Error Message : \(error.localizedDescription)")
        }
    }
}

struct AppleLoginView_Previews: PreviewProvider {
    static var previews: some View {
        AppleLoginView()
    }
}
