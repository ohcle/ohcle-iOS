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
    @AppStorage("isLoggedIn") var isLoggedIn : Bool = UserDefaults.standard.bool(forKey: "isLoggedIn")
        
    @State private var appleLoginViewSize: CGSize = CGSize()
        
    @FetchRequest(sortDescriptors: []) var diary: FetchedResults<Diary>
    @Environment(\.managedObjectContext) var moc

    private let mainLogoTitle: String
    private let url: URL
    private let defualtURL: String = "http://www.google.com"
    private let usePolicy = "[서비스 이용약관](https://www.notion.so/e14abf614bfd407a9f7570ec67ebd2c0?pvs=4)"
    private let privatePolicy = "[개인정보 정책](https://www.notion.so/da12179df28d4010ac91e3d652bfd855?pvs=4)"
    
    init(mainLogoTitle: String, receptionURL: URL?) {
        self.mainLogoTitle = mainLogoTitle
        if let url = receptionURL {
            self.url = url
        } else {
            self.url = URL(string: defualtURL)!
        }
    }
        
    var body: some View {
        if isLoggedIn {
            MainView()
        } else {
            VStack(alignment: .center) {
                createMainLogo()
                showMainGreetings()
                    .multilineTextAlignment(.center)
                KakaoLoginView()
                    .padding(.bottom, 11)

                AppleLoginView()
                    .aspectRatio(CGSize(width: 7, height: 1.2),
                                 contentMode: .fit)
                    .padding(.bottom, 32)
                
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
            
        }.minimumScaleFactor(0.5)
            .font(.title)
            .lineLimit(1)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(mainLogoTitle: "main logo",
                  receptionURL: URL(string: ""))
    }
}
