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

final class LoginManager: ObservableObject {
    @AppStorage("userNickName") var userNickName: String = ""
    @AppStorage("userImageString") var userImageString: String = ""
    @AppStorage("isLoggedIn") var isLoggedIn : Bool = UserDefaults.standard.bool(forKey: "isLoggedIn")
    @AppStorage("ohcleID") var ohcleToken: String = ""
    
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
    func saveOhcleToken(loginResult: LoginResultModel) {
        DispatchQueue.main.async {
            LoginManager.shared.ohcleToken = loginResult.accessToken
        }
    }
    
    private func decodeAndSaveLoginResult(_ data: Data) -> Bool {
        do {
            let decodedData = try JSONDecoder().decode(LoginResultModel.self, from: data)
            
            LoginManager.shared.saveOhcleToken(loginResult: decodedData)
            
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
    func singInAppleAccount(_ result : Result<ASAuthorization, Error>) async {
        if await self.isAppleLoginSucceded(result) {
            do {
                let loginResultData = try await requestLogin()
                decodeAndSaveLoginResult(data: loginResultData)
                withAnimation {
                    signIn()
                }
            } catch {
                
            }
        }
        
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
        print(url)
        var request = try URLRequest(url: url, method: .post)
        let para = ["social_id": "\(kakaoUserID)",
                    "nickname": nickName,
                    "gender": "male"]
        print(para)
        
        let httpBody = try JSONSerialization.data(withJSONObject: para, options: [])
        request.httpBody = httpBody
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (loginResult, response) = try await URLSession.shared.data(for: request)
        
        if let response = response as? HTTPURLResponse,
           response.statusCode != 200 {
            print("reponse Code is :\(response.statusCode)")
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
        await logoutOhcleAccount()
        withAnimation {
            DispatchQueue.main.async {
                self.isLoggedIn = false
            }
        }
    }
    
    func signOut() async {
        clearUserDefaults()
        signOutAppleAccount()
        signOutKakaoAccount()
        await signOutOhcleAccount()
        
        DispatchQueue.main.async {
            withAnimation {
                self.isLoggedIn = false
            }
        }
    }
    
    private func clearUserDefaults() {
        UserDefaults.standard.removeObject(forKey: "userImageString")
        UserDefaults.standard.removeObject(forKey: "userNickName")
        UserDefaults.standard.removeObject(forKey: "didSeeOnBoarding")
        UserDefaults.standard.removeObject(forKey: "isLoggedIn")
        UserDefaults.standard.removeObject(forKey: "ohcleToken")
        UserDefaults.standard.removeObject(forKey: "isLoggohcleIDedIn")
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
    }
    
    private func signOutOhcleAccount() async {
        let ohcleID = LoginManager.shared.ohcleToken
        print(ohcleID)
        
        let urlString = "https://api-gw.todayclimbing.com/v1/user/\(ohcleID)"
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        do {
            let request = try URLRequest(url: url, method: .delete)
            let (_, response) = try await URLSession.shared.data(for: request)
            
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                print(response)
            }
        } catch {
            print(error)
        }
    }
    
    private func logoutOhcleAccount() async {
        let urlString = "https://api-gw.todayclimbing.com/v1/user/\(self.ohcleToken)/signout"
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        do {
            let request = try URLRequest(url: url, method: .patch)
            let (_, response) = try await URLSession.shared.data(for: request)
            
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                print(response)
            }
        } catch {
            print(error)
        }
    }
}
