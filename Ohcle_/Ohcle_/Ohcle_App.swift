//
//  Ohcle_App.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2022/10/04.
//

import SwiftUI

@main
struct Ohcle_App: App {
    private let loginView = LoginView(mainLogoTitle: "main logo", receptionURL: URL(string: ""))

    var body: some Scene {
        WindowGroup {
            if loginView.isLoggedIn {
                loginView
            } else {
                LoginSuccessView()
            }
        }
    }
}
