//
//  MyPageLogoutView.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2022/11/12.
//

import SwiftUI
import KakaoSDKUser

struct MyPageUserInfoView: View {
    @EnvironmentObject var loginSetting: LoginSetting
    @AppStorage("isLoggedIn") var isLoggedIn : Bool = UserDefaults.standard.bool(forKey: "isLoggedIn")
    let thumbnailImage: Image
    let userName: String
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center, spacing: 20) {
                Spacer()
                //                Image("mypage-logout-placeholder")
                thumbnailImage
                    .resizable()
                    .frame(width: 200, height: 200)
                    .clipShape(Circle())
                
                (Text("계정\n")
                    .foregroundColor(.gray)
                 +
                 Text(String(userName))
                    .foregroundColor(.black)
                )
                .multilineTextAlignment(.center)
                
                Button {
                    withAnimation {
                        self.isLoggedIn = false
                    }
                } label: {
                    Text("로그아웃")
                        .font(.body)
                        .frame(width: geometry.size.width * 8/10
                        )
                        .padding()
                        .background(Color("saveButtonColor"))
                        .cornerRadius(8)
                        .foregroundColor(.white)
                }
                .padding(.bottom, 76)
                
                Button {
                    withAnimation {
                        self.isLoggedIn = false
                    }
                    DispatchQueue.global().async {
                        UserApi.shared.unlink {(error) in
                            if let error = error {
                                print(error)
                            }
                            else {
                                print("unlink() success.")
                            }
                        }
                    }
                } label: {
                    Text("탈퇴하기")
                        .foregroundColor(.black)
                }
                Spacer()
            }.padding()
        }
    }
}


struct MyPageLogoutView_Previews: PreviewProvider {
    static var image: Image = Image("")
    static var name: String = ""
    
    static var previews: some View {
        MyPageUserInfoView(thumbnailImage: image, userName: name)
    }
}
