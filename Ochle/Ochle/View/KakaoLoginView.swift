//
//  KakaoLoginView.swift
//  Ochle
//
//  Created by Do Yi Lee on 2022/09/30.
//

import SwiftUI
import KakaoSDKUser

struct KakaoLoginView: View {
    @State var isLogedIn: Bool = false
    
    var body: some View {
        Button {
            if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                    print(oauthToken)
                    print(error)
                }
            } else {
                UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                    print(oauthToken)
                print(error)
                }
            }
        } label : {
            Image("kakao_login_medium_wide")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width : UIScreen.main.bounds.width * 0.9)
        }
    }
}

struct KakaoLoginView_Previews: PreviewProvider {
    static var previews: some View {
        KakaoLoginView()
    }
}
