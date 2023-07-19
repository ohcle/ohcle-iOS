//
//  MyPageLogoutView.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2022/11/12.
//

import SwiftUI
import KakaoSDKUser
import AuthenticationServices

struct MyPageUserInfoView: View {
    @AppStorage("isLoggedIn") var isLoggedIn : Bool = UserDefaults.standard.bool(forKey: "isLoggedIn")
    @Binding var thumbnailImage: Image
    @Binding var userName: String
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center, spacing: 20) {
                Spacer()
                thumbnailImage
                    .resizable()
                    .frame(width: 170, height: 170)
                    .clipShape(Circle())
                
                (Text("계정\n")
                    .foregroundColor(.gray)
                    .bold()
                 +
                 Text(String(userName))
                    .foregroundColor(.black)
                )
                .multilineTextAlignment(.center)
                
                Button {
                    Task {
                        await LoginManager.shared.logOut()
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
                
                Spacer()
                
                Button {
                    Task {
                        await LoginManager.shared.signOut()
                    }
                } label: {
                    Text("탈퇴하기")
                        .foregroundColor(.gray)
                        .bold()
                }
                
                Spacer()
                
            }.padding()
        }
    }
}


struct MyPageLogoutView_Previews: PreviewProvider {
    @State static var image: Image = Image("mypage-profile-placeholder")
    @State static var name: String = ""
    
    static var previews: some View {
        MyPageUserInfoView(thumbnailImage: $image, userName: $name)
    }
}
