//
//  AppleLoginView.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2022/11/24.
//

import SwiftUI
import _AuthenticationServices_SwiftUI

struct AppleLoginView: View {
    typealias AppleLoginReslutType = [String: Any]
    @EnvironmentObject var loginSetting: LoginSetting
    @State private var isLoginError: Bool = false
    
    var body: some View {
        SignInWithAppleButton(.continue) { request in
            request.requestedScopes = [.email, .fullName]
        } onCompletion: { result in
            let loginResult = filterAppleLoginResult(result)
            Task {
                let data = try await fetchTokenData(loginResult)
//                UserTokenManager.shared.save(token: data, account: .apple, service: .login)
            }
        }
        .alert("Apple Login Error", isPresented: $isLoginError) {
            Text("Apple Login Error")
        }
    }
    
    struct AppleLoginUserInfo {
        let first_name: String?
        let last_name: String?
        let email: String
        let user_id: Int
        
        var parameter: [String: Any] {
            return ["first_name": first_name ?? "무명의클라이머",
                    "last_name": last_name ?? "",
                    "email": email,
                    "user_id": user_id]
        }
    }
    
    private func fetchTokenData(_ appleLoginResult: AppleLoginReslutType) async throws -> Data {
        let tokenURL = getAccessTokenURL(.appleLogin)
        
//        let parameters: [String: Any] = ["first_name": "도이",
//                                         "last_name": "이",
//                                         "email": "dlehdl7989@gmail.com",
//                                         "user_id": 12345]
        
        var request = try URLRequest(url: tokenURL, method: .post)
        request.httpBody = try JSONSerialization.data(withJSONObject: appleLoginResult)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let response = response as? HTTPURLResponse,
           response.statusCode != 200 {
            print("reponse Code is :\(response.statusCode)")
            self.isLoginError.toggle()
            return Data()
        }
        
        return data
    }
    
    private func filterAppleLoginResult(_ result: Result<ASAuthorization, Error>) -> AppleLoginReslutType {
        switch result {
        case .success(let auth):
            if let credential = auth.credential as? ASAuthorizationAppleIDCredential {
                let userId = credential.user
                let firstName = credential.fullName?.familyName
                let lastName = credential.fullName?.givenName
                
                let email = credential.email ?? "ohcle@gmail.com"
                
                let userInfo = AppleLoginUserInfo(first_name: firstName, last_name: lastName, email: email, user_id: 123)
                
                return userInfo.parameter
            }

            self.loginSetting.login()
            
        case .failure(let error):
            print("Apple Login Error. Error Message : \(error.localizedDescription)")
        }
        
        let emptyDictionary = ["":""]
        return emptyDictionary
    }
}

struct AppleLoginView_Previews: PreviewProvider {
    static var previews: some View {
        AppleLoginView()
    }
}
