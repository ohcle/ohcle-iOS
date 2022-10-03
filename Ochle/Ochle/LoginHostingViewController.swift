//
//  LoginHostingViewController.swift
//  Ochle
//
//  Created by Do Yi Lee on 2022/09/29.
//

import SwiftUI
import KakaoSDKCommon
import KakaoSDKAuth

class LoginViewHostingController: UIHostingController<MainView> {
    required init?(coder aDecoder: NSCoder) {
        let mainView = MainView()
        KakaoSDK.initSDK(appKey: "e78a0ba0d7372b5370db8c893fd2d881")
        super.init(coder: aDecoder, rootView: MainView())
    }
}
