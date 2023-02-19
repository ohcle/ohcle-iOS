//
//  KakaoLoginView.swift
//  Ochle
//
//  Created by Do Yi Lee on 2022/09/30.
//

import SwiftUI
import KakaoSDKUser

struct KakaoLoginView: View {
    @EnvironmentObject var kakaoLoginSetting: LoginSetting
    
    var body: some View {
        Button {
            if (UserApi.isKakaoTalkLoginAvailable()) {
                UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                    toggleLoginSetting(oauthToken)
                }
            } else {
                UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                    toggleLoginSetting(oauthToken)
                    let toeknErrorMessage = ""
                    let accessToken: String = oauthToken?.accessToken ?? toeknErrorMessage
                    Task {
                        let data = try await fetchTokenData(kakaAccessToken: accessToken)
                        UserTokenManager.shared.save(token: data, account: .kakao, service: .login)
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
       
        return data
    }
}
