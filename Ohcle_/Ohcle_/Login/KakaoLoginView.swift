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

extension UserApi {
    public func me(propertyKeys: [String]? = nil,
                   secureResource: Bool = true) async -> User? {
        return await withCheckedContinuation { continuation in
            AUTH_API.responseData(.get,
                                  Urls.compose(path:Paths.userMe),
                                  parameters: ["property_keys": propertyKeys?.toJsonString(), "secure_resource": secureResource].filterNil(),
                                  apiType: .KApi) { (response, data, error) in
                if let data = data {
                    do {
                        let user = try? SdkJSONDecoder.customIso8601Date.decode(User.self, from: data)
                        continuation.resume(returning: user)
                    }
                } else {
                    continuation.resume(returning: nil)
                }
            }
        }
    }
}

struct KakaoLoginView: View {
    var body: some View {
        Button {
             //MARK: 카카오톡 존재 시
            if (UserApi.isKakaoTalkLoginAvailable()) {
                UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                    
                    if let error =  error {
                        AlertManager.shared.showAlert(message: "\(error.localizedDescription)")
                    }
                    
                    Task {
                        await LoginManager.shared.signInKakaoAccount()
                    }
                }
            } else {
                UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                    if let error =  error {
                        AlertManager.shared.showAlert(message: "\(error.localizedDescription)")
                    }
                    
                    Task {
                        await LoginManager.shared.signInKakaoAccount()
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
}

