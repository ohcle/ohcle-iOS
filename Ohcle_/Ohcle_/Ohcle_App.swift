//
//  Ohcle_App.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2022/10/04.
//

import SwiftUI
import KakaoSDKCommon

@main
struct Ohcle_App: App {
    private let loginView = LoginView(mainLogoTitle: "main logo",
                                      receptionURL: URL(string: ""))
    init() {
          // Kakao SDK 초기화
          KakaoSDK.initSDK(appKey: "e78a0ba0d7372b5370db8c893fd2d881")
      }
    
    var body: some Scene {
        WindowGroup {
           loginView
        }
    }
}

//
//  var body: some Scene {
//      WindowGroup {
//          // onOpenURL()을 사용해 커스텀 URL 스킴 처리
//          ContentView().onOpenURL(perform: { url in
//              if (AuthApi.isKakaoTalkLoginUrl(url)) {
//                  AuthController.handleOpenUrl(url: url)
//              }
//          })
//      }
//  }
