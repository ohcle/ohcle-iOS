//
//  LoginManger.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2023/05/27.
//

import Foundation
import SwiftUI
import AuthenticationServices
import KakaoSDKUser
import KakaoSDKAuth
import KakaoSDKCommon
import Alamofire

final class LoginManager: ObservableObject {
    @AppStorage("userNickName") var userNickName: String = ""
    @AppStorage("userImageString") var userImageString: String = ""
    @AppStorage("isLoggedIn") var isLoggedIn : Bool = UserDefaults.standard.bool(forKey: "isLoggedIn")
    @AppStorage("ohcleID") var ohcleAccessToken: String = ""
    @AppStorage("ohcleRefreshToken") var ohcleRefreshToken: String = ""
    @AppStorage("AppleClientSecret") var appleClientSecret: String = ""
    @AppStorage("AppleToken") var appleToken: String = ""

    @Published var currentLoggedIn: Bool = false
    
    @State private var errorMessages: String = "에러가 없습니다."
    @State private var isError: Bool = false
    
    private (set) var userEmail: String = ""
    private (set) var userFirstName: String = ""
    private (set) var userLastName: String = ""
    private (set) var userID: String = ""
    
    private init() { }
    static let shared = LoginManager()
    
    enum UserInfo: String {
        case userID
        case userEmail
        case userFirstName
        case userLastName
        
        case profileURLString
        case userNickName
    }
    
    //MARK: - Common methods
    private func saveOhcleToken(loginResult: LoginResultModel) {
        DispatchQueue.main.async {
            self.ohcleAccessToken = loginResult.accessToken
            self.ohcleRefreshToken = loginResult.refreshToken
        }
    }
    
    private func decodeAndSaveLoginResult(_ data: Data) -> Bool {
        do {
            let decodedData = try JSONDecoder().decode(LoginResultModel.self, from: data)
            
            self.saveOhcleToken(loginResult: decodedData)
            
            return true
        } catch {
            _ = error.localizedDescription
            return false
        }
    }
    
    private func signIn() {
        DispatchQueue.main.async {
            self.isLoggedIn = true
        }
    }
    
    //MARK: - Sign in Apple
    func singInWithAppleAccount(_ credential: ASAuthorizationAppleIDCredential) async {
        saveApplLoginUsrInfo(credential: credential)
        do {
            let loginResultData = try await requestOhcleLogin()
            
            guard (loginResultData as Data?) != nil else {
                self.deleteUserInformation()
                return
            }
            
            decodeAndSaveLoginResult(data: loginResultData)
            
            withAnimation {
                signIn()
            }
        } catch {
            
        }
    }
    
    private func saveApplLoginUsrInfo(credential: ASAuthorizationAppleIDCredential) {
        let userID = credential.user
        
        let firstName = credential.fullName?.familyName ?? ""
        let lastName = credential.fullName?.givenName ?? "무명의 클라이머"
        let email = credential.email ?? "ohcle@gmail.com"
        
        self.saveAppleUserInformation(userID: userID,
                                      firstName: firstName,
                                      lastName: lastName,
                                      email: email)
    }
    
    private func saveAppleUserInformation(userID: String, firstName: String,
                                          lastName: String, email: String) {
        self.userFirstName = firstName
        self.userLastName = lastName
        self.userEmail = email
        self.userID = userID
        DispatchQueue.main.async {
            self.userNickName = firstName + lastName
        }
    }
    
    private func requestOhcleLogin() async throws -> Data? {
        let url = getAccessTokenURL(.appleLogin)
        var request = try URLRequest(url: url, method: .post)
        
        let parameter = ["social_id": userID,
                         "nickname": (userFirstName + userLastName),
                         "gender": "female"]
        
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
    
    
    //MARK: - Sign in Kakao
    func signInKakaoAccount() async {
        let userInfo = await saveKakaoUserInfomation()
        
        if let userID = userInfo[.userID] as? String?, userID ==  nil {
            return
        }
        
        do {
            let userIDInt = Int(userInfo[.userID] as? Int64 ?? .zero)
            let isSucceded = try await isValidOhcleUser(kakaoUserID: userIDInt,
                                                        nickName: LoginManager.shared.userNickName)
            
            if isSucceded {
                withAnimation {
                    signIn()
                    print(self.ohcleAccessToken, "카카오 로그인 시 토큰")
                }
            } else {
                self.errorMessages = "사용자 정보 반환 후 카카오 로그인 실패"
            }
            
        } catch {
            self.errorMessages = error.localizedDescription
        }
    }
    
    private func saveKakaoUserInfomation() async -> [UserInfo: Any?] {
        let user = await UserApi.shared.me()
        let urlString = user?.properties?["profile_image"] ?? ""
        let userNickName = user?.properties?["nickname"] ?? "오클"
        
        DispatchQueue.main.async {
            self.userNickName = userNickName
            self.userImageString = urlString
        }
        
        return [.userID: user?.id,
                .profileURLString: urlString,
                .userNickName: userNickName]
    }
    
    private func isValidOhcleUser(kakaoUserID: Int,
                                  nickName: String,
                                  gender: String? = nil) async throws -> Bool {
        let url = getAccessTokenURL(.kakaoLogin)
        
        var request = try URLRequest(url: url, method: .post)
        let para = ["social_id": "\(kakaoUserID)",
                    "nickname": nickName,
                    "gender": "male"]
        
        let httpBody = try JSONSerialization.data(withJSONObject: para, options: [])
        request.httpBody = httpBody
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (loginResult, response) = try await URLSession.shared.data(for: request)
        
        if let response = response as? HTTPURLResponse,
           response.statusCode != 200 {
            print("Response Code is: \(response.statusCode)")
            let errorData = try JSONSerialization.jsonObject(with: loginResult, options: []) as? [String: Any]
            let errorMessage = errorData?["message"] as? String
            throw NSError(domain: "NetworkE  rror", code: response.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage ?? ""])
        }
        
        
        return decodeAndSaveLoginResult(loginResult)
    }
    
    private func defineKakaoLoginError(_ error: Error) {
        if let sdkError = error as? SdkError, sdkError.isInvalidTokenError() == true  {
            print("Known KakaoLogin Error : \(error)")
        }
        else {
            print("Unknown KakaoLogin Error : \(error)")
        }
    }
    
    private func checkAndRefreshToken() {
        if (AuthApi.hasToken()) {
            UserApi.shared.accessTokenInfo { (_, error) in
                if let error = error {
                    if let sdkError = error as? SdkError,
                       sdkError.isInvalidTokenError() == true  {
                        self.errorMessages = sdkError.localizedDescription
                        self.isError = true
                    } else {
                        self.errorMessages = "사용자 토큰 오류"
                        self.isError = true
                        
                    }
                }
            }
        }
    }
    
    //MARK: - Log out, Sing out
    func logOut() async {
        let logoutResult = await logoutOhcleAccount()
        
        if logoutResult {
            withAnimation {
                DispatchQueue.main.async {
                    self.isLoggedIn = false
                }
            }
            clearUserDefaults()
            signOutAppleAccount()
            signOutKakaoAccount()
        }
    }
    
    private func deleteUserInformation() {
        self.userFirstName = ""
        self.userLastName = ""
        self.userEmail = ""
        self.userID = ""
    }
    
    func signOut() async {
        await signOutOhcleAccount()
    }
    
    private func clearUserDefaults() {
        UserDefaults.standard.removeObject(forKey: "userImageString")
        UserDefaults.standard.removeObject(forKey: "userNickName")
        UserDefaults.standard.removeObject(forKey: "didSeeOnBoarding")
        UserDefaults.standard.removeObject(forKey: "isLoggedIn")
        
        UserDefaults.standard.removeObject(forKey: "ohcleID")
        UserDefaults.standard.removeObject(forKey: "ohcleRefreshToken")
        
        UserDefaults.standard.removeObject(forKey: "isLoggohcleIDedIn")
        UserDefaults.standard.removeObject(forKey: "AppleClientSecret")
        UserDefaults.standard.removeObject(forKey: "AppleToken")
    }

    private func signOutKakaoAccount() {
        UserApi.shared.unlink {(error) in
            if let error = error {
                print(error)
            } else {
                print("unlink() success.")
            }
        }
    }
    
    private func signOutAppleAccount() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedOperation = .operationLogout
        
        //error
        print("clientSecret: \(self.appleClientSecret) token: \(self.appleToken))")
        
        revokeAppleToken(clientSecret: self.appleClientSecret,
                         token: self.appleToken) {
            print("Finished")
        }
    }
    
    private func revokeAppleToken(clientSecret: String,
                                  token: String,
                                  completionHandler: @escaping () -> Void) {
        guard let bundleIdentifier = Bundle.main.bundleIdentifier else {
            return
        }
           let url = "https://appleid.apple.com/auth/revoke?client_id=\(bundleIdentifier)&client_secret=\(clientSecret)&token=\(token)&token_type_hint=refresh_token"
           let header: HTTPHeaders = ["Content-Type": "application/x-www-form-urlencoded"]

           AF.request(url,
                      method: .post,
                      headers: header)
           .validate(statusCode: 200..<600)
           .responseData { response in
               
               guard let statusCode = response.response?.statusCode else { return }
               
               if statusCode == 200 {
                   print("애플 토큰 삭제 성공!")
                   completionHandler()
               } else {
                   print(statusCode)
               }
           }
       }
    
    
    private func signOutOhcleAccount() async {
        let urlString = "http://13.125.173.42/v1/user/me"
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        do {
            var request = try URLRequest(url: url, method: .delete)
            request.addValue("Bearer \(self.ohcleAccessToken)", forHTTPHeaderField: "Authorization")
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let response = response as? HTTPURLResponse,
               response.statusCode == 204 {
                DispatchQueue.main.async {
                    withAnimation {
                        self.isLoggedIn = false
                    }
                }
                
                clearUserDefaults()
                signOutAppleAccount()
                signOutKakaoAccount()
                
                CalendarDataManger.shared.record.clearRecord()
                //FIXME: UserToken 구분 및 revoke 상태확인 필요
                AlertManager.shared.showAlert(message: "탈퇴가 완료되었습니다.")
            } else {
                let _ = String(data: data, encoding: .utf8)
            }
            
        } catch {
            print(error)
        }
    }
    
    private func logoutOhcleAccount() async -> Bool {
        let urlString = "http://13.125.173.42/user/logout"
        
        guard let url = URL(string: urlString) else {
            return false
        }
        
        do {
            var request = try URLRequest(url: url, method: .post)
            request.headers.add(name: "Authorization", value: "Bearer \(self.ohcleAccessToken)")

            let para = ["access": self.ohcleAccessToken,
                        "refresh": self.ohcleRefreshToken]
            let httpBody = try JSONSerialization.data(withJSONObject: para, options: [])
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = httpBody
            
            let (_, response) = try await URLSession.shared.data(for: request)
            
            guard let response = response as? HTTPURLResponse else {
                print(response)
                return false
            }
            
            return isLogoutSucceded(responseCode: response.statusCode)
        } catch {
            print(error)
            return false
        }
    }
    
    private func isLogoutSucceded(responseCode: Int) -> Bool {
        if responseCode == 204 {
            return true
        } else {
            return false
        }
    }
}
