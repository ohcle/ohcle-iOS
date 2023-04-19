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
    //서비스 공지링크 : https://stirring-heart-712.notion.site/50fa7a8de5a54b47b007786c3a1a0c8c
    private let myPageSettingList: [MyPageSetting] = [
        MyPageSetting(type: .userInfo, title: "계정\n annamong@gmail.com", iconImageString: "mypage-profile-placeholder"),
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
                    MyPageViewRow(settingList: myPageSettingList[0])
                }
                
                NavigationLink {
                    UserAlarmSettingView()
                } label: {
                    MyPageViewRow(settingList: myPageSettingList[1])
                }
                
                MyPageRowLinkView(settingList: myPageSettingList[2])
                MyPageRowLinkView(settingList: myPageSettingList[3])
                MyPageRowLinkView(settingList: myPageSettingList[4])
                MyPageRowLinkView(settingList: myPageSettingList[5])
            }
        }
    }
}


struct MyPageView_Previews: PreviewProvider {
    static var previews: some View {
        MyPageView()
    }
}
