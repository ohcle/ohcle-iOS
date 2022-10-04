//
//  ContentView.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2022/10/04.
//

import SwiftUI

struct ContentView: View {
    private let loginView = LoginView(mainLogoTitle: "main logo",
                                      receptionURL: URL(string: ""))
    @State var isLoggedIn: Bool = false
    
    var body: some View {
        VStack {
            if isLoggedIn {
                LoginSuccessView()
            } else {
                loginView
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
