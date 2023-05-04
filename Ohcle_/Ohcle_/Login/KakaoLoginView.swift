//
//  KakaoLoginView.swift
//  Ochle
//
//  Created by Do Yi Lee on 2022/09/30.
//

import SwiftUI
import KakaoSDKUser
import KakaoSDKAuth
import KakaoSDKCommon

struct KakaoLoginView: View {
    @EnvironmentObject var kakaoLoginSetting: LoginSetting
    @AppStorage("userID") private var userNickName = ""
    @AppStorage("userImage") private var userImageString: String = ""
    
    @AppStorage("isLoggedIn") var isLoggedIn : Bool = UserDefaults.standard.bool(forKey: "isLoggedIn")
    
    var body: some View {
        Button {
            //MARK: - 카카오톡 토큰 여부 확인
            if AuthApi.hasToken() {
                checkAndRefreshToken()
            }
            else {
                //로그인 필요
            }
            
            //MARK: - 카카오톡 실행 여부 확인
            if (UserApi.isKakaoTalkLoginAvailable()) {
                UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                    print(oauthToken?.accessToken)
                    
                    UserApi.shared.me { user, error in
                        self.userNickName = user?.properties?["nickname"] ?? "오클"
                        print(self.userNickName)
                        
                        let urlString = user?.properties?["profile_image"] ?? ""
                        self.userImageString = urlString
                    }
                    
                    let toeknErrorMessage = ""
                    let accessToken: String = oauthToken?.accessToken ?? toeknErrorMessage
                    
                    Task {
                        do {
                            let isSucceded = try await isValidOhcleUser(kakaoAccessToken: accessToken,
                                                                        nickName: self.userNickName)
                            
                            if isSucceded {
                                self.isLoggedIn = true
                            }
                        } catch {
                            print(error)
                        }
                    }
                }
                
            } else {
                UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                    print(oauthToken?.accessToken)
                    UserApi.shared.me { user, error in
                        self.userNickName = user?.properties?["nickname"] ?? "오클"
                        print(self.userNickName)
                        
                        let urlString = user?.properties?["profile_image"] ?? ""
                        self.userImageString = urlString
                    }
                    
                    let toeknErrorMessage = ""
                    let accessToken: String = oauthToken?.accessToken ?? toeknErrorMessage
                    Task {
                        do {
                            let isSucceded = try await isValidOhcleUser(kakaoAccessToken: accessToken, nickName: self.userNickName)
                            if isSucceded {
                                self.isLoggedIn = true
                            }
                        } catch {
                            print(error)
                        }
                    }
                }
            }
        } label : {
            Image("kakao_login_medium_wide_Anna")
                .resizable()
                .frame(width : UIScreen.main.bounds.width * 0.813)
                .aspectRatio(CGSize(width: 7, height: 1.1),
                             contentMode: .fit)
        }
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
        UserApi.shared.accessTokenInfo { (tokenInfo, error) in
            if let error = error {
                defineKakaoLoginError(error)
            }
        }
    }
    
    //    private func saveUserKeychain(token: ) {
    //        let mockData: [String: Any] = ["isNewbie": true,
    //                                       "token": "test"]
    //        UserTokenManager.shared.save(token: decodedData["token"] as? String ?? "", account: .kakao, service: .login)
    //    }
    
    private func isValidOhcleUser(kakaoAccessToken: String,
                                  nickName: String, gender: String? = nil) async throws -> Bool {
        
        let url = getAccessTokenURL(.kakaoLogin)
        var request = try URLRequest(url: url, method: .post)
        
        request.setValue("232586", forHTTPHeaderField: "id")
        request.setValue("Joy", forHTTPHeaderField: "nickname")
        request.setValue("", forHTTPHeaderField: "gender")
        
        let para = ["id": "232586", "nickname": "Joy", "gender": ""]
        
        let httpBody = try JSONSerialization.data(withJSONObject: para) ??  Data()
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let response = response as? HTTPURLResponse,
           response.statusCode != 200 {
            print("reponse Code is :\(response.statusCode)")
            print(response.url, response.headers, response.allHeaderFields)
        }
        
#if DEBUG
        do {
            print(data)
            let decodedData = try JSONDecoder().decode(LoginResultModel.self, from: data)
            return true
        } catch {
            print(error)
            return true
        }
        
#endif
        do {
            print(data)
            let decodedData = try JSONDecoder().decode(LoginResultModel.self, from: data)
            
            return true
        } catch {
            print(error)
            return false
        }
    }
}

