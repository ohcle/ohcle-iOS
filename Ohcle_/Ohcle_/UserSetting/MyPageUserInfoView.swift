//
//  MyPageLogoutView.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2022/11/12.
//

import SwiftUI

struct MyPageUserInfoView: View {
    @EnvironmentObject var loginSetting: LoginSetting
    @AppStorage("isLoggedIn") var isLoggedIn : Bool = UserDefaults.standard.bool(forKey: "isLoggedIn")
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center, spacing: 20) {
                Image("mypage-logout-placeholder")
                
                (Text("계정\n")
                    .foregroundColor(.gray)
                 +
                    Text("annamong@gmail.com")
                    .foregroundColor(.black)
                )
                .multilineTextAlignment(.center)

                
                Button {
                    withAnimation {
                        //self.loginSetting.isLoggedIn = false
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
                    
                } label: {
                    Text("탈퇴하기")
                        .foregroundColor(.black)
                }
                
            }.padding()
            
        }
    }
}


struct MyPageLogoutView_Previews: PreviewProvider {
    static var previews: some View {
        MyPageUserInfoView()
    }
}
