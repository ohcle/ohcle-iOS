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

final class LoginManager: ObservableObject {
    @AppStorage("userNickName") var userNickName: String = ""
    @AppStorage("userImageString") var userImageString: String = ""
    @AppStorage("isLoggedIn") var isLoggedIn : Bool = UserDefaults.standard.bool(forKey: "isLoggedIn")
//    @AppStorage("ohcleToken") var ohcleToken: Int = .zero
    @AppStorage("ohcleID") var ohcleID: Int = .zero
    
    @Published var currentLoggedIn: Bool = false
    
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
    
    func saveOhcleToken(loginResult: LoginResultModel) {
        DispatchQueue.main.async {
            LoginManager.shared.ohcleID = loginResult.userID
//            LoginManager.shared.ohcleID = loginResult.userID
            
            print(self.ohcleID)
        }
    }
    
    func saveKakaoUserInfomation() async -> [UserInfo: Any?] {
        let user = await UserApi.shared.me()
        let urlString = user?.properties?["profile_image"] ?? ""
        let userNickName = user?.properties?["nickname"] ?? "오클"
        
        DispatchQueue.main.async {
            self.userNickName = userNickName
            self.userImageString = urlString
        }
        
        print(user)
        return [.userID: user?.id,
                .profileURLString: urlString,
                .userNickName: userNickName]
    }
    
    func saveAppleUserInformation(userID: String, firstName: String,
                                  lastName: String, email: String) {
        self.userFirstName = firstName
        self.userLastName = lastName
        self.userEmail = email
        self.userID = userID
        
        self.userNickName = firstName + lastName
    }
    
    func isOhcleUserSignedIn() -> Bool {
        return self.isLoggedIn
    }
    
    func signIn() {
        self.isLoggedIn = true
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
        let ohcleID = LoginManager.shared.ohcleID
        print(ohcleID)
        
        let urlString = "https://api-gw.todayclimbing.com/v1/user/\(ohcleID)"
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        do {
            let request = try URLRequest(url: url, method: .delete)
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                print(response)
            }
            
            print(String(data: data, encoding: .utf8))
            
        } catch {
            print(error)
        }
    }
    
    private func logoutOhcleAccount() async {
        let urlString = "https://api-gw.todayclimbing.com/v1/user/\(self.ohcleID)/signout"
        
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
