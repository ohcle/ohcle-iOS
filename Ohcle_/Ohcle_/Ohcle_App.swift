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
    
    @State var didSeeOnBoarding: Bool = UserDefaults.standard.bool(forKey: "didSeeOnBoarding")
    @StateObject private var alertManager = AlertManager.shared
    @StateObject private var progressManger = ProgressManager.shared
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                LoginView(mainLogoTitle: "main logo",
                          receptionURL: URL(string: ""))
                .onOpenURL { url in
                    if (AuthApi.isKakaoTalkLoginUrl(url)) {
                        _ =  AuthController.handleOpenUrl(url: url)
                    }
                }
                .preferredColorScheme(.light)
                
                if !didSeeOnBoarding {
                    OnBoardingView {
                        didSeeOnBoarding = true
                        UserDefaults.standard.set(true, forKey: "didSeeOnBoarding")
                        
                        #if DEBUG // 지속적으로 OnBoarding 화면 확인을 위함
                        UserDefaults.standard.set(true, forKey: "didSeeOnBoarding")
                        #endif
                        
                    }
                }
                
                if progressManger.isShowing {
                    VStack {
                        Spacer()
                        HStack {
                            ProgressView("Loading")
                        }
                        .frame(width: UIScreen.screenWidth)
                        Spacer()
                    }
                    .frame(height: UIScreen.screenHeight)
                    .background(.gray)
                    .opacity(0.5)
                }
                
                
            }
            .alert(isPresented: $alertManager.isShowingAlert) {
                Alert(title: Text(""), message: Text(alertManager.alertMessage))
            }
//            .environmentObject(alertManager)
            
        }
    }
    
}

class AlertManager: ObservableObject {
    static let shared = AlertManager()

    @Published var isShowingAlert = false
    @Published var alertMessage = ""

    private init() {}

    func showAlert(message: String) {
        DispatchQueue.main.async {
            self.alertMessage = message
            self.isShowingAlert = true
        }
    }

    func hideAlert() {
        DispatchQueue.main.async {
            self.isShowingAlert = false
            self.alertMessage = ""
        }
    }
}


class ProgressManager: ObservableObject {
    static let shared = ProgressManager()
    @Published var isShowing = false
    private init() {}

    func show(){
        DispatchQueue.main.async {
            self.isShowing = true
        }
    }

    func hide(){
        DispatchQueue.main.async {
            self.isShowing = false
        }
    }
}
