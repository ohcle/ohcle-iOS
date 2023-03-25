//
//  Ohcle_App.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2022/10/04.
//

import SwiftUI
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser


@main
struct Ohcle_App: App {
    init() {
        // Kakao SDK 초기화
        KakaoSDK.initSDK(appKey: "e78a0ba0d7372b5370db8c893fd2d881")
        
        if(AuthApi.hasToken()) {
            UserApi.shared.accessTokenInfo { info, error in
                if let error = error {
                    if let sdkError = error as? SdkError, sdkError.isInvalidTokenError() ==  true {
                        
                    } else {
                        print("Unknown Kakao Login Error")
                    }
                } else {
                    UserApi.shared.me { user, error in
                       // user.
                    }
//                    let kakaoTokenData = UserTokenManager.shared.read(account: .kakao, service: .login)
//                    let tokenString = String(decoding: kakaoTokenData ?? Data(), as: UTF8.self)
//                    print(tokenString)
                    // token validation
                }
            }
        } else {
            // login
        }
    }
    
    @StateObject private var persistenceController = DataController.shared

    var body: some Scene {
        WindowGroup {
            LoginView(mainLogoTitle: "main logo",
                      receptionURL: URL(string: "")).environmentObject(LoginSetting())
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .onOpenURL { url in
                    if (AuthApi.isKakaoTalkLoginUrl(url)) {
                        _ =  AuthController.handleOpenUrl(url: url)
                    }
                }
        }
    }
}

