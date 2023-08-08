//
//  AppleLoginView.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2022/11/24.
//

import SwiftUI
import _AuthenticationServices_SwiftUI
import SwiftJWT
import Alamofire

struct AppleLoginView: View {
    @ObservedObject var vm = LoginViewModel()
    
    var body: some View {
        CustomSocialButton() {
            vm.performAppleSignIn()
        }
        .onReceive(vm.$isSuccessed) { isSuccessed in
            if !isSuccessed {
                AlertManager.shared.showAlert(message: "\(vm.errorMessage)")
                vm.isSuccessed = true
                vm.errorMessage = ""
            }
        }
        
    }
}

final class LoginViewModel: NSObject, ASAuthorizationControllerDelegate, ObservableObject {
    
    @Published var isSuccessed: Bool = true
    @Published var errorMessage: String?
    
    func authorizationController(controller: ASAuthorizationController,
                                 didCompleteWithAuthorization authorization: ASAuthorization) {
        
        //cliend_secret 만들기
        guard let appleIdCredential = authorization.credential as?
                ASAuthorizationAppleIDCredential else {
            self.isSuccessed = false
            self.errorMessage = "appleIdCredential error"
            return
        }
        
        let cliendID = generateJWT()
        saveAppleCliendSecret(signedJWT: cliendID)
        
        guard let authorizationCodeLiteral = String(data: appleIdCredential.authorizationCode ?? Data(), encoding: .utf8) else {
            self.isSuccessed = false
            self.errorMessage = "authorizationCodeLiteral error"
            return
        }
        

        getAppleRefreshToken(code: authorizationCodeLiteral) { [weak self] token in
            guard let token = token else {
                self?.isSuccessed = false
                self?.errorMessage = "getAppleRefreshToken error"
                return
            }
            
            self?.saveAppleToken(token)
        }
        
        Task {
            await LoginManager.shared.singInWithAppleAccount(appleIdCredential)
        }
    }
    
    
    func authorizationController(controller: ASAuthorizationController,
                                 didCompleteWithError error: Error) {
        self.isSuccessed = false
        self.errorMessage = error.localizedDescription
    }
    
    func performAppleSignIn() {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.performRequests()
    }

    
    private func saveAppleCliendSecret(signedJWT: String) {
//        UserDefaults.standard.set(signedJWT, forKey: "AppleClientSecret")
        LoginManager.shared.appleClientSecret = signedJWT
    }
    
    private func saveAppleToken(_ tokenLiteral: String) {
        LoginManager.shared.appleToken = tokenLiteral
//        UserDefaults.standard.set(tokenLiteral, forKey: "AppleToken")
    }
    
    private func generateJWT() -> String {
        let myHeader = Header(kid: "D74JT58G9V")
        
        struct MyClaims: Claims {
            let iss: String
            let iat: Int
            let exp: Int
            let aud: String
            let sub: String
        }

        guard let bundleIdentifier = Bundle.main.bundleIdentifier else {
            return "bundleIdentifier error"
        }
        
        let iat = Int(Date().timeIntervalSince1970)
        let exp = iat + 3600
        let myClaims = MyClaims(iss: "7MJ69FU8BU",
                                iat: iat,
                                exp: exp,
                                aud: "https://appleid.apple.com",
                                sub: bundleIdentifier)
        
        var myJWT = JWT(header: myHeader, claims: myClaims)
        
        guard let url = Bundle.main.url(forResource: "AuthKey_D74JT58G9V",
                                        withExtension: "p8") else {
            let errorMessage = "p8 file error"
            self.errorMessage = errorMessage
            self.isSuccessed = false
            
            return errorMessage
        }
        
        let privateKey: Data = try! Data(contentsOf: url, options: .alwaysMapped)
        let jwtSigner = JWTSigner.es256(privateKey: privateKey)
        let signedJWT = try! myJWT.sign(using: jwtSigner)
        
        print("🗝 singedJWT - \(signedJWT)")
        
        return signedJWT
    }
    
    struct AppleTokenResponse: Decodable {
        let access_token: String
        let token_type: String
        let expires_in: Int
        let refresh_token: String
        let id_token: String
    }
    
    private func getAppleRefreshToken(code: String,
                                      completionHandler: @escaping (String?) -> Void) {
        guard let secret = UserDefaults.standard.string(forKey: "AppleClientSecret") else {
            return
        }
        
        guard let bundleIdentifier = Bundle.main.bundleIdentifier else {
            return
        }

        let url = "https://appleid.apple.com/auth/token?client_id=\(bundleIdentifier)&client_secret=\(secret)&code=\(code)&grant_type=authorization_code"
        let header: HTTPHeaders = ["Content-Type": "application/x-www-form-urlencoded"]
        
        print("🗝 clientSecret - \(UserDefaults.standard.string(forKey: "AppleClientSecret"))")
        print("🗝 authCode - \(code)")
        
        AF.request(url, method: .post,
                   encoding: JSONEncoding.default,
                   headers: header)
        .validate(statusCode: 200..<500)
        .responseData { response in
            print("🗝 response - \(response.description)")
            
            switch response.result {
            case .success(let output):
                print("🗝 ouput - \(output)")
                let decoder = JSONDecoder()
                
                do {
                    let decodedData = try decoder.decode(AppleTokenResponse.self, from: output)
                    print("🗝 output2 - \(decodedData.refresh_token)")
                    
                    if decodedData.refresh_token == nil {
                        self.errorMessage = "apple API refresh token is nil"
                        self.isSuccessed = false
                    } else {
                        completionHandler(decodedData.refresh_token)
                    }
                } catch(let error) {
                    print(error.localizedDescription)
                }
                
                
            case .failure(let errorOutput) :
                self.errorMessage = "ResponseCode: \(errorOutput.responseCode), \(errorOutput.localizedDescription)"
                self.isSuccessed = false
            }
        }
    }
}

struct AppleLoginView_Previews: PreviewProvider {
    static var previews: some View {
        AppleLoginView()
    }
}

struct CustomSocialButton: View {
    private let image: String = "koreanAppleLoginButtonImage"
    var action: (() -> ())?
    
    var body: some View{
        HStack{
            Button(
                action: {
                    action?()
                },
                label: {
                    Image(image)
                        .resizable()
                        .frame(width : UIScreen.main.bounds.width * 0.813)
                        .aspectRatio(CGSize(width: 7, height: 1.1),
                                     contentMode: .fit)
                })
        }
    }
}
