//
//  KakaoLoginView.swift
//  Ochle
//
//  Created by Do Yi Lee on 2022/09/30.
//

import SwiftUI
import KakaoSDKUser
import KakaoSDKAuth
import KakaoSDKCommon

extension Notification.Name {
    static let kakaoLoginError = Notification.Name("kakaoLoginError")
    static let nonValidUserError = Notification.Name("nonValidUserError")
}

extension UserApi {
    public func me(propertyKeys: [String]? = nil,
                   secureResource: Bool = true) async -> User? {
        return await withCheckedContinuation { continuation in
            AUTH_API.responseData(.get,
                                  Urls.compose(path:Paths.userMe),
                                  parameters: ["property_keys": propertyKeys?.toJsonString(), "secure_resource": secureResource].filterNil(),
                                  apiType: .KApi) { (response, data, error) in
                if let data = data {
                    do {
                        let user = try? SdkJSONDecoder.customIso8601Date.decode(User.self, from: data)
                        continuation.resume(returning: user)
                    } catch {
                        continuation.resume(returning: nil)
                    }
                } else {
                    continuation.resume(returning: nil)
                }
            }
        }
    }
}

struct KakaoLoginView: View {
    @EnvironmentObject var kakaoLoginSetting: LoginSetting
    @AppStorage("userID") private var userNickName = ""
    @AppStorage("userImage") private var userImageString: String = ""
    
    @AppStorage("isLoggedIn") var isLoggedIn : Bool = UserDefaults.standard.bool(forKey: "isLoggedIn")
    @State private var userID: Int64? = .zero
    
    fileprivate func fetchKakaoUserInfomation() async {
        let user = await UserApi.shared.me()
        let urlString = user?.properties?["profile_image"] ?? ""
        let userNickName = user?.properties?["nickname"] ?? "오클"
        
        self.userNickName = userNickName
        self.userID = user?.id
        self.userImageString = urlString
    }
    
    var body: some View {
        Button {
            //MARK: 카카오톡 토큰 여부 확인
            if AuthApi.hasToken() {
                checkAndRefreshToken()
            }
            
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                Task {
                    await fetchKakaoUserInfomation()
                    do {
                        let userIDInt = Int(self.userID ?? .zero)
                        let isSucceded = try await isValidOhcleUser(kakaoUserID: userIDInt, nickName: self.userNickName)
                        
                        if isSucceded {
                            self.isLoggedIn = true
                        }
                    } catch {
                        let errorMessage = error.localizedDescription
                        NotificationCenter.default
                            .post(name: .nonValidUserError, object: errorMessage)
                    }
                }
            }
        } label : {
            Image("kakao_login_medium_wide_Anna")
                .resizable()
                .frame(width : UIScreen.main.bounds.width * 0.813)
                .aspectRatio(CGSize(width: 7, height: 1.1),
                             contentMode: .fit)
        }
    }
    
    private func isValidOhcleUser(kakaoUserID: Int,
                                  nickName: String, gender: String? = nil) async throws -> Bool {
        let url = getAccessTokenURL(.kakaoLogin)
        var request = try URLRequest(url: url, method: .post)
        let para = ["id": "\(kakaoUserID)",
                    "nickname": nickName,
                    "gender": gender]
        
        let httpBody = try JSONSerialization.data(withJSONObject: para, options: [])
        request.httpBody = httpBody
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (loginResult, response) = try await URLSession.shared.data(for: request)
        
        if let response = response as? HTTPURLResponse,
           response.statusCode != 200 {
            print("reponse Code is :\(response.statusCode)")
        }
        
        return isValidLoginResult(loginResult)
    }
    
    private func defineKakaoLoginError(_ error: Error) {
        if let sdkError = error as? SdkError, sdkError.isInvalidTokenError() == true  {
            print("Known KakaoLogin Error : \(error)")
        }
        else {
            print("Unknown KakaoLogin Error : \(error)")
        }
    }
    
    private func checkAndRefreshToken() {
        UserApi.shared.accessTokenInfo { (tokenInfo, error) in
            if let error = error {
                defineKakaoLoginError(error)
                NotificationCenter.default.post(name: .kakaoLoginError, object: nil)
            }
        }
    }
    
    private func isValidLoginResult(_ data: Data) -> Bool {
        do {
            let decodedData = try JSONDecoder().decode(AppleLoginResultModel.self, from: data)
            UserTokenManager.shared.save(token: decodedData.token,
                                         account: .kakao,
                                         service: .login)
            
            return true
        } catch {
            let errorMessage = error.localizedDescription
            NotificationCenter.default.post(name: .kakaoLoginError, object: errorMessage)
            return false
        }
    }
}

