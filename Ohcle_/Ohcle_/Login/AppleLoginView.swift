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
                    if await isAppleLoginSucceded(result) {
                        do {
                            let loginResultData = try await requestLogin()
                            decodeAndSaveLoginResult(data: loginResultData)
                            withAnimation {
                                LoginManager.shared.signIn()
                            }
                        } catch {
                            
                        }
                    }
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
    
    private func requestLogin() async throws -> Data? {
        let url = getAccessTokenURL(.appleLogin)
        var request = try URLRequest(url: url, method: .post)
        let parameter = ["id": LoginManager.shared.userID,
                         "first_name": LoginManager.shared.userFirstName,
                         "last_name": LoginManager.shared.userLastName,
                         "email": LoginManager.shared.userEmail,
                    "gender": ""]
        
        let httpBody = try JSONSerialization.data(withJSONObject: parameter, options: [])
        request.httpBody = httpBody
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (loginResult, response) = try await URLSession.shared.data(for: request)
        
        if let response = response as? HTTPURLResponse,
           response.statusCode != 200 {
            print("reponse Code is :\(response.statusCode)")
            return nil
        }
        
        return loginResult
    }
    
    private func decodeAndSaveLoginResult(data: Data?) {
        if let data = data {
            do {
                let decodedData = try JSONDecoder().decode(LoginResultModel.self, from: data)
                LoginManager.shared.saveOhcleToken(loginResult: decodedData)
            } catch {
                let errorMessage = error.localizedDescription
                print(errorMessage)
            }
        } else {
            return
        }
    }
    
    private func isAppleLoginSucceded(_ result: Result<ASAuthorization, Error>) async -> Bool {
        switch result {
        case .success(let auth):
            if let credential = auth.credential as? ASAuthorizationAppleIDCredential {
                let userID = credential.user
                
                let firstName = credential.fullName?.familyName ?? ""
                let lastName = credential.fullName?.givenName ?? "무명의 클라이머"
                let email = credential.email ?? "ohcle@gmail.com"
                print("🎉🎉🎉🎉🎉", firstName, lastName, email)
                LoginManager.shared.saveAppleUserInformation(userID: userID, firstName: firstName, lastName: lastName, email: email)
                return true
            }

        case .failure(let error):
            print("Apple Login Error. Error Message : \(error.localizedDescription)")
            return false
        }
        return false
    }

}

struct AppleLoginView_Previews: PreviewProvider {
    static var previews: some View {
        AppleLoginView()
    }
}
