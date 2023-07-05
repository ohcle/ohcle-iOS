//
//  MyPageView.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2022/11/12.
//

import SwiftUI

struct MyPageSetting: Identifiable {
    enum PageType: String {
        case userInfo
        case userAlarm
        case serviceNotification
        case personalInfo
        case servicePolicy
        case customerService
    }
    
    let id: UUID = UUID()
    let type: PageType
    let title: String
    let iconImageString: String
}

struct MyPageViewRow: View {
    let settingList: MyPageSetting
    var body: some View {
        HStack {
            Image(settingList.iconImageString)
                .padding(.trailing, 10)
            Text(settingList.title)
        }
    }
}

struct MyPageRowLinkView: View {
    let settingList: MyPageSetting
    var body: some View {
        HStack {
            Image(settingList.iconImageString)
                .padding(.trailing, 10)
            if let url = URL(string: settingList.type.rawValue) {
                Link(settingList.title, destination: url)
                    .foregroundColor(.black)
                
            } else {
                Text(settingList.title)
            }
        }
    }
}

struct MyPageView: View {
    @State private var userName: String = ""
    @State private var userImage: Image = Image("mypage-profile-placeholder")
    
    private let myPageSettingList: [MyPageSetting] = [
        MyPageSetting(type: .userAlarm, title: "알림",
                      iconImageString: "mypage-alarm"),
        MyPageSetting(type: .serviceNotification, title: "서비스 공지",
                      iconImageString: "mypage-service-noti"),
        MyPageSetting(type: .personalInfo, title: "개인정보 보호정책",
                      iconImageString: "mypage-personal-info"),
        MyPageSetting(type: .servicePolicy, title: "서비스 이용약관", iconImageString: "mypage-use-service"),
        MyPageSetting(type: .customerService, title: "문의", iconImageString: "ohcle_question")
    ]
     
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: MyPageUserInfoView(thumbnailImage: $userImage, userName: $userName)) {
                    HStack {
                        userImage
                            .resizable()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                        Text("계정\n\(userName)")
                    }
                }
                
                MyPageRowLinkView(settingList: myPageSettingList[1])
                    .onTapGesture {
                        openURL(ExternalOhcleLinks.serviceInfomation)
                    }
                MyPageRowLinkView(settingList: myPageSettingList[2])
                    .onTapGesture {
                        openURL(ExternalOhcleLinks.personalInfoPolicy)
                    }
                
                MyPageRowLinkView(settingList: myPageSettingList[3])
                    .onTapGesture {
                        openURL(ExternalOhcleLinks.userServiceManual)
                    }
                
                MyPageRowLinkView(settingList: myPageSettingList[4])
                    .onTapGesture {
                        openURL(ExternalOhcleLinks.customerSurport)
                    }
            }
        }
        .onAppear {
            let userDefaultsName = UserDefaults.standard.object(forKey: "userNickName")
            if let nickName = userDefaultsName as? String {
                self.userName = nickName
            } else {
                self.userName = "ohcle"
            }
            
            let userDefaults = UserDefaults.standard.object(forKey: "userImageString")
            if let userImageString = userDefaults as? String,
               let url = URL(string: userImageString) {
                do {
                    guard let request = try? URLRequest(url: url, method: .get) else {
                        self.userImage = Image("")
                        return
                    }
                    
                    URLSession.shared.dataTask(with: request) { data, response, error in
                        let uiImage = UIImage(data: data ?? Data())
                        let image = Image(uiImage: uiImage ?? UIImage())
                        self.userImage = image
                    }
                    .resume()
                    
                }
            }
        }
    }
    
    private func openURL(_ urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}


struct MyPageView_Previews: PreviewProvider {
    static var previews: some View {
        MyPageView()
    }
}

