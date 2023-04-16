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
        KakaoSDK.initSDK(appKey: "e78a0ba0d7372b5370db8c893fd2d881")
    }
    
    @StateObject private var persistenceController = DataController.shared
    @State var didSeeOnBoarding: Bool = UserDefaults.standard.bool(forKey: "didSeeOnBoarding")
    @State private var isLoaded: Bool = false
    
    var body: some Scene {
        WindowGroup {
            Group {
                if isLoaded {
            ZStack {
                LoginView(mainLogoTitle: "main logo",
                          receptionURL: URL(string: "")).environmentObject(LoginSetting())
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    .onOpenURL { url in
                        if (AuthApi.isKakaoTalkLoginUrl(url)) {
                            _ =  AuthController.handleOpenUrl(url: url)
                        }
                    }
                
                if !didSeeOnBoarding {
                    OnBoardingView {
                        didSeeOnBoarding = true
                        UserDefaults.standard.set(true, forKey: "didSeeOnBoarding")
                        
                        #if DEBUG // 지속적으로 OnBoarding 화면 확인을 위함
                        UserDefaults.standard.set(false, forKey: "didSeeOnBoarding")
                        #endif
                    }
                }
            }
                }
                else {
                     SplashView()
                }

            }
            .onAppear {
                // Simulate loading time
                isLoaded = true
            }
}

