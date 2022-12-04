//
//  AppleLoginView.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2022/11/24.
//

import SwiftUI
import _AuthenticationServices_SwiftUI

struct AppleLoginView: View {
    @EnvironmentObject var loginSetting: LoginSetting
    
    var body: some View {
        SignInWithAppleButton(.continue) { request in
            request.requestedScopes = [.email, .fullName]
        } onCompletion: { result in
            handleAppleLoginResult(result)
            createToken()
        }
    }
    
    private func createToken() {
        guard let url = URL(string: "https://ohcle.net/v1/account/apple/signin") else {
            return
        }
        
        do {
            var request = try URLRequest(url: url, method: .post)
            let parameters: [String: Any] = ["first_name": "오", "last_name": "클","email": "ohcle@gmail.com", "user_id": 567889]
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                print(response?.description)
                print(error.debugDescription)
                do {
                    if let requestedData = data {
                        let decodedData = try JSONDecoder().decode(LoginResultModel.self, from: requestedData)
                        print(decodedData.userToken)
                    }
                } catch {
                    print(error)
                }
            }.resume()
    
        } catch {
            print(error)
        }
    }
    
    private func handleAppleLoginResult(_ result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let auth):
            switch auth.credential {
            case let credential as ASAuthorizationAppleIDCredential:
                let userId = credential.user
                let email = credential.email
                let fullName = credential.fullName
                self.loginSetting.login()
                
            default:
                break
            }
        case .failure(let error):
            //Add Alert
            print(error)
        }
    }
}

struct AppleLoginView_Previews: PreviewProvider {
    static var previews: some View {
        AppleLoginView()
    }
}
