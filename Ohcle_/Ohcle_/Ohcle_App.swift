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
        /// Kakao SDK 초기화
        KakaoSDK.initSDK(appKey: "b61a430c747ede3f63f1f02fba513526")
    }
    
    @StateObject private var persistenceController = DataController.shared
    @State var didSeeOnBoarding: Bool = UserDefaults.standard.bool(forKey: "didSeeOnBoarding")
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                LoginView(mainLogoTitle: "main logo",
                          receptionURL: URL(string: "")).environmentObject(LoginSetting())
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    .onOpenURL { url in
                        if (AuthApi.isKakaoTalkLoginUrl(url)) {
                            _ =  AuthController.handleOpenUrl(url: url)
                        }
                    }
                    .environment(\.colorScheme, .light)

                
                if !didSeeOnBoarding {
                    OnBoardingView {
                        didSeeOnBoarding = true
                        UserDefaults.standard.set(true, forKey: "didSeeOnBoarding")
                        
                        #if DEBUG // 지속적으로 OnBoarding 화면 확인을 위함
                        UserDefaults.standard.set(true, forKey: "didSeeOnBoarding")
                        #endif
                    }
                }
            }
        }
    }
}

