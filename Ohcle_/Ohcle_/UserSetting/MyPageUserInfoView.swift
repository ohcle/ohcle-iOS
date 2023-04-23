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
    @EnvironmentObject var loginSetting: LoginSetting
    @AppStorage("isLoggedIn") var isLoggedIn : Bool = UserDefaults.standard.bool(forKey: "isLoggedIn")
    @Binding var thumbnailImage: Image
    @Binding var userName: String
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center, spacing: 20) {
                Spacer()
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
                    clearUserDefaults()
                    UserApi.shared.unlink {(error) in
                        if let error = error {
                            print(error)
                        }
                        else {
                            print("unlink() success.")
                            withAnimation {
                                self.isLoggedIn = false
                                signOutUser()
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
    
    private func clearUserDefaults() {
        UserDefaults.standard.removeObject(forKey: "userImage")
        UserDefaults.standard.removeObject(forKey: "userID")
        UserDefaults.standard.removeObject(forKey: "didSeeOnBoarding")
        UserDefaults.standard.removeObject(forKey: "isLoggedIn")
    }
    
    func signOutUser() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedOperation = .operationLogout
        
        
    }
}


//struct MyPageLogoutView_Previews: PreviewProvider {
//    static var image: Image = Image("")
//    static var name: String = ""
//    
//    static var previews: some View {
//        MyPageUserInfoView(thumbnailImage: image, userName: name)
//    }
//}
