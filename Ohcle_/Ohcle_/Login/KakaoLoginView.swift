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

var kakaoToken = ""

struct KakaoLoginView: View {
    @EnvironmentObject var kakaoLoginSetting: LoginSetting
    
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
            else {
                
            }
        }
    }
    
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
                    toggleLoginSetting(oauthToken)
                }
            } else {
                UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                    let toeknErrorMessage = ""
                    let accessToken: String = oauthToken?.accessToken ?? toeknErrorMessage
                    Task {
                        do {
                            try await fetchTokenData(kakaAccessToken: accessToken)
                        } catch {
                            print(error)
                        }

                    }
            
//                    let test = "test"
//                    let testData = test.data(using: .utf8) ?? Data()
//                    UserTokenManager.shared.save(token: testData, account: .kakao, service: .login)
                    toggleLoginSetting(oauthToken)
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
    
    private func toggleLoginSetting(_ oauthToken: Codable?) {
        if oauthToken == nil {
            self.kakaoLoginSetting.isLoggedIn = false
        } else {
            self.kakaoLoginSetting.isLoggedIn = true
        }
    }
    
    private func fetchTokenData(kakaAccessToken: String) async throws -> Data {
        let url = getAccessTokenURL(.kakaoLogin)
        let parameters: [String: Any] = ["access_token": kakaAccessToken]
        var request = try URLRequest(url: url, method: .post)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let response = response as? HTTPURLResponse,
           response.statusCode != 200 {
            print("reponse Code is :\(response.statusCode)")
        }
        
        UserTokenManager.shared.save(token: data, account: .kakao, service: .login)
        
        return data
    }
    
}
