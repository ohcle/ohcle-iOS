//
//  LoginView.swift
//  Ochle
//
//  Created by Do Yi Lee on 2022/09/28.
//

import SwiftUI
import AuthenticationServices
import KakaoSDKAuth


enum GreetingTextOptions: String {
    case todaysClimbing = "오늘의 클라이밍"
    case timeToStart = "시작할 시간!"
}

struct LoginView: View {
    private let mainLogoTitle: String
    private let url: URL
    private let defualtURL: String = "http://www.google.com"
    
    init(mainLogoTitle: String, receptionURL: URL?) {
        self.mainLogoTitle = mainLogoTitle
        if let url = receptionURL {
            self.url = url
        } else {
            self.url = URL(string: defualtURL)!
        }
    }
    
    var body: some View {
        VStack(alignment: .center) {
            Image(mainLogoTitle)
                .resizable()
                .scaledToFit()
                .aspectRatio(CGSize(width: 1, height: 1), contentMode: .fit)
                .padding(.horizontal, 30)
                .padding(.bottom, 10)

            HStack(spacing: 3) {
                Text(GreetingTextOptions.todaysClimbing.rawValue)
                    .font(.title)
                    .bold()
                
                Text(GreetingTextOptions.timeToStart.rawValue)
                    .font(.title)
            }
            .padding(.bottom, 11.0)
            
            KakaoLoginView()
                .aspectRatio(CGSize(width: 7, height: 1) , contentMode: .fit)
                    .padding(.bottom, 11)
            
            SignInWithAppleButton(.continue) { request in
                request.requestedScopes = [.email, .fullName]
            } onCompletion: { result in
                switch result {
                case .success(let auth):
                    switch auth.credential {
                    case let credential as ASAuthorizationAppleIDCredential:
                        let userId = credential.user
                        let email = credential.email
                        let fullName = credential.fullName
                       
                    default:
                        break
                    }
                case .failure(let error):
                    print(error)
                }
            }
            .aspectRatio(CGSize(width: 7, height: 1) , contentMode: .fit)
                .padding(.bottom, 32)
                .cornerRadius(5)
                
            Link("문의하기", destination: url)
                .font(.body)
                .bold()
                .foregroundColor(.black)
        }.padding(.horizontal, 35)

    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(mainLogoTitle: "main logo", receptionURL: URL(string: ""))
    }
}
