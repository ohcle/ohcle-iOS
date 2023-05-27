//
//  LoginManger.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2023/05/27.
//

import Foundation
import SwiftUI
import KakaoSDKUser
import AuthenticationServices

final class LoginManager {
    @AppStorage("userNickName") var userNickName: String = ""
    @AppStorage("userImageString") var userImageString: String = ""
    @AppStorage("isLoggedIn") private var isLoggedIn : Bool = UserDefaults.standard.bool(forKey: "isLoggedIn")
    @AppStorage("ohcleToken") var ohcleToken = ""
    @AppStorage("ohcleID") var ohcleID: Int = .zero
    
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
    
    func saveKakaoUserInfomation() async -> [UserInfo: Any?] {
        let user = await UserApi.shared.me()
        let urlString = user?.properties?["profile_image"] ?? ""
        let userNickName = user?.properties?["nickname"] ?? "오클"
        
        self.userNickName = userNickName
        self.userImageString = urlString
        
        return [.userID: user?.id,
                .profileURLString: urlString,
                .userNickName: userNickName]
    }
    
    func saveOhcleToken(loginResult: LoginResultModel) {
        LoginManager.shared.ohcleToken = loginResult.token
        LoginManager.shared.ohcleID = loginResult.userID
    }
    
    func saveAppleUserInformation(userID: String, firstName: String, lastName: String, email: String) {
        self.userFirstName = firstName
        self.userLastName = lastName
        self.userEmail = email
        self.userID = userID
        
        self.userNickName = firstName + lastName
    }
    
    func signIn() {
        withAnimation {
            self.isLoggedIn = true
        }
    }
    
    func logOut() async {
        await logoutOhcleAccount()
        withAnimation {
            self.isLoggedIn = false
        }
    }

    func signOut() async {
        clearUserDefaults()
        signOutAppleAccount()
        signOutKakaoAccount()
        await signOutOhcleAccount()
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
                withAnimation {
                    self.isLoggedIn = false
                }
            }
        }
    }
    
    private func signOutAppleAccount() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedOperation = .operationLogout
        
        withAnimation {
            self.isLoggedIn = false
        }
    }
    
    private func signOutOhcleAccount() async {
        guard let token = UserDefaults.standard.string(forKey: "ohcleToken") else {
            return
        }
        
        let urlString = "https://api-gw.todayclimbing.com/v1/user/\(token)"
        
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
