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
        case serviceNotification = "https://www.google.com"
        case personalInfo = "https://www.google.com1"
        case servicePolicy = "https://www.google.com2"
        case customerService = "https://www.google.com3"
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
    private let userName: String = {
        let userDefaults = UserDefaults.standard.object(forKey: "userID")
        if let nickName = userDefaults as? String {
            return nickName
        } else {
            return "ohcle"
        }
    }()
    
    private let userImage: Image = {
        let userDefaults = UserDefaults.standard.object(forKey: "userImage")
        if let userImageData = userDefaults as? Data,
           let userUIImage = UIImage(data: userImageData) {
            let image = Image(uiImage: userUIImage)
            return image
        } else {
            return Image("mypage-profile-placeholder")
        }
    }()
   
    private let myPageSettingList: [MyPageSetting] = [
        MyPageSetting(type: .userAlarm, title: "알림",
                      iconImageString: "mypage-alarm"),
        MyPageSetting(type: .serviceNotification, title: "서비스 공지",
                      iconImageString: "mypage-service-noti"),
        MyPageSetting(type: .personalInfo, title: "개인정보",
                      iconImageString: "mypage-personal-info"),
        MyPageSetting(type: .servicePolicy, title: "서비스이용", iconImageString: "mypage-use-service"),
        MyPageSetting(type: .customerService, title: "문의", iconImageString: "mypage-question")
    ]
    
    var body: some View {
        NavigationStack {
            List {
                NavigationLink {
                    MyPageUserInfoView()
                        
                } label: {
                    HStack {
                        userImage
                            .padding(.trailing, 10)
                        Text("계정\n \(userName)")
                    }
                }
                
                NavigationLink {
                    UserAlarmSettingView()
                } label: {
                    MyPageViewRow(settingList: myPageSettingList[0])
                }
                
                MyPageRowLinkView(settingList: myPageSettingList[1])
                MyPageRowLinkView(settingList: myPageSettingList[2])
                MyPageRowLinkView(settingList: myPageSettingList[3])
                MyPageRowLinkView(settingList: myPageSettingList[4])
            }
        }
    }
}


struct MyPageView_Previews: PreviewProvider {
    static var previews: some View {
        MyPageView()
    }
}
