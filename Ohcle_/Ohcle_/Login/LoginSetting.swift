//
//  LoginSetting.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2022/10/04.
//

import SwiftUI

final class LoginSetting: ObservableObject {
    @Published var isLoggedIn: Bool = false

    func login() {
        self.isLoggedIn = true
    }
}


