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
    @State private var appleLoginViewSize: CGSize = CGSize()
    @ObservedObject var loginManager = LoginManager.shared
    @State private var isError: Bool = false
    
    private let mainLogoTitle: String
    private let receptionURL: URL
    private let usePolicy: URL
    private let privatePolicy: URL
    private let informationLinkFont: Font = .caption2
    
    init(mainLogoTitle: String) {
        self.mainLogoTitle = mainLogoTitle
        self.receptionURL = URL(string: ExternalOhcleLinks.customerSurport)!
        
        self.usePolicy = URL(string: ExternalOhcleLinks.serviceInfomation)!
        self.privatePolicy = URL(string: ExternalOhcleLinks.personalInfoPolicy)!
    }
    
    var body: some View {
        if loginManager.isLoggedIn {
            MainView()
        } else {
            VStack(alignment: .center) {
                createMainLogo()
                showMainGreetings()
                    .multilineTextAlignment(.center)
                
                KakaoLoginView()
                    .padding(.bottom, 11)
                    .padding(.leading, 20)
                    .padding(.trailing, 20)

                AppleLoginView()
                    .padding(.bottom, 32)
                    .padding(.leading, 20)
                    .padding(.trailing, 20)
                
                Link(destination: receptionURL) {
                    Text("문의하기")
                        .font(.body)
                        .bold()
                        .foregroundColor(.black)
                        .padding(.bottom, 30)
                        .padding(.top, 40)
                }
                
                HStack(spacing: 0) {
                    Text("로그인시 ")
                    Link(destination: self.usePolicy) {
                        Text("서비스 이용약관")
                            .underline()
                            .accentColor(.black)
                    }
                    
                    Text(" 및 ")
                    
                    Link(destination: self.privatePolicy) {
                        Text("개인정보 이용약관")
                            .underline()
                            .accentColor(.black)
                    }
                    
                    Text("에")
                }
                .font(informationLinkFont)

                Text(" 동의하는 것으로 간주합니다.")
                    .font(informationLinkFont)

            }
            .padding(.horizontal, 35)
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
        ZStack {
            Text(GreetingTextOptions.todaysClimbing.rawValue + " ")
                .fontWeight(.bold)
            +
            Text(GreetingTextOptions.timeToStart.rawValue)
            
        }
        .minimumScaleFactor(0.5)
        .font(.title)
        .lineLimit(1)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(mainLogoTitle: "main logo")
    }
}
