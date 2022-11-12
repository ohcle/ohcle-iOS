//
//  LoginView.swift
//  Ochle
//
//  Created by Do Yi Lee on 2022/09/28.
//

import SwiftUI
import AuthenticationServices
import KakaoSDKAuth
import KakaoSDKUser

enum GreetingTextOptions: String {
    case todaysClimbing = "오늘의 클라이밍"
    case timeToStart = "시작할 시간!"
}



struct LoginView: View {
    @StateObject var loginSetting = LoginSetting()
    
    private let mainLogoTitle: String
    private let url: URL
    private let defualtURL: String = "http://www.google.com"
    
    private let usePolicy = "[서비스 이용약관](https://www.google.com)"
    private let privatePolicy = "[서비스 이용약관](https://www.google.com)"
    
    init(mainLogoTitle: String, receptionURL: URL?) {
        self.mainLogoTitle = mainLogoTitle
        if let url = receptionURL {
            self.url = url
        } else {
            self.url = URL(string: defualtURL)!
        }
    }
    
    private func createMainLogo() -> some View {
        return Image(mainLogoTitle)
            .resizable()
            .scaledToFit()
            .frame(minWidth: 150, maxWidth: 250, minHeight: 150, maxHeight: 250)
            .padding(.bottom, 10)
            .padding(.top, 50)
    }
    
    private func showMainGreetings() -> some View {
        return
        ZStack {
            Text(GreetingTextOptions.todaysClimbing.rawValue + " ")
                .fontWeight(.bold)
            +
            Text(GreetingTextOptions.timeToStart.rawValue)
            
        }.minimumScaleFactor(0.5)
            .font(.title)
            .lineLimit(1)
    }
    
    private func handleAppleLoginResult(_ result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let auth):
            switch auth.credential {
            case let credential as ASAuthorizationAppleIDCredential:
                let userId = credential.user
                let email = credential.email
                let fullName = credential.fullName
                self.loginSetting.login()
                
            default:
                break
            }
        case .failure(let error):
            print(error)
        }
    }
    
    var body: some View {
        if self.loginSetting.isLoggedIn {
            LoginSuccessView()
        } else {
            VStack(alignment: .center) {
                createMainLogo()
                showMainGreetings()
                    .multilineTextAlignment(.center)
                
                Button {
                    if (UserApi.isKakaoTalkLoginAvailable()) {
                        UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                            self.loginSetting.isLoggedIn = true
                            print(oauthToken)
                            print(error)
                        }
                    } else {
                        UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                            self.loginSetting.isLoggedIn = true
                            
                            print(oauthToken)
                            print(error)
                        }
                    }
                } label : {
                    Image("kakao_login_medium_wide_Anna")
                        .resizable()
                        .frame(minWidth: UIScreen.main.bounds.width * 0.82, minHeight: UIScreen.main.bounds.height * 0.054)
                        .aspectRatio(contentMode: .fit)
                }
                
                .aspectRatio(CGSize(width: 7, height: 1),
                             contentMode: .fit)
                .padding(.bottom, 11)
                
                SignInWithAppleButton(.continue) { request in
                    request.requestedScopes = [.email, .fullName]
                } onCompletion: { result in
                    handleAppleLoginResult(result)
                }
                .aspectRatio(CGSize(width: 7, height: 1.2) , contentMode: .fit)
                .padding(.bottom, 32)
                .cornerRadius(5)
                
                Link("문의하기", destination: url)
                    .font(.body)
                    .bold()
                    .foregroundColor(.black)
                    .padding(.bottom, 100)
                
                ZStack {
                    Text("로그인시 ")
                    + Text(.init(self.usePolicy))
                        .underline()
                    + Text(" 및 ")
                    + Text(.init(self.privatePolicy))
                        .underline()
                    + Text("에 \n 동의하는 것으로 간주합니다.")
                }.accentColor(.black)
                    .font(.caption)
                    .multilineTextAlignment(.center)
                
            }.padding(.horizontal, 35)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(mainLogoTitle: "main logo",
                  receptionURL: URL(string: ""))
    }
}
