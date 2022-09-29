//
//  LoginHostingViewController.swift
//  Ochle
//
//  Created by Do Yi Lee on 2022/09/29.
//

import UIKit

import UIKit
import SwiftUI

class LoginViewHostingController: UIHostingController<LoginView> {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder, rootView: LoginView(mainLogoTitle: "main logo", receptionURL: URL(string: "")))
    }
}
