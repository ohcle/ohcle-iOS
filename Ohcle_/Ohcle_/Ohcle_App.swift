//
//  Ohcle_App.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2022/10/04.
//

import SwiftUI
import KakaoSDKCommon

class ViewSizeManager {
    private init() { }
    
    static let shared = ViewSizeManager()
    private(set) var size: CGSize = CGSize(width: 0, height: 0)
    
    func updateViewSize(_ cgSize: CGSize) {
        ViewSizeManager.shared.size = cgSize
    }
}

var cgsize: CGSize = CGSize()

@main
struct Ohcle_App: App {
    init() {
        // Kakao SDK 초기화
        KakaoSDK.initSDK(appKey: "e78a0ba0d7372b5370db8c893fd2d881")
    }
    
    @StateObject private var persistenceController = DataController()

    var body: some Scene {
        WindowGroup {
            LoginView(mainLogoTitle: "main logo",
                      receptionURL: URL(string: "")).environmentObject(LoginSetting())
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
