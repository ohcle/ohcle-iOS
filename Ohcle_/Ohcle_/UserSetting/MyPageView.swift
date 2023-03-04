//
//  MyPageView.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2022/11/12.
//

import SwiftUI

struct MyPageSetting: Identifiable {
    let id: UUID = UUID()
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

struct MyPageView: View {
    //서비스 공지링크 : https://stirring-heart-712.notion.site/50fa7a8de5a54b47b007786c3a1a0c8c
    let myPageSettingList: [MyPageSetting] = [
        MyPageSetting(title: "계정\n annamong@gmail.com", iconImageString: "mypage-profile-placeholder"),
        MyPageSetting(title: "", iconImageString: ""),
        MyPageSetting(title: "알림",
                      iconImageString: "mypage-alarm"),
        MyPageSetting(title: "서비스 공지",
                      iconImageString: "mypage-service-noti"),
        MyPageSetting(title: "개인정보",
                      iconImageString: "mypage-personal-info"),
        MyPageSetting(title: "서비스이용", iconImageString: "mypage-use-service"),
        MyPageSetting(title: "문의", iconImageString: "mypage-question")
    ]
    
    var body: some View {
        let gridItem: [GridItem] = [
            GridItem(.flexible())
        ]
        
        ScrollView {
            LazyVGrid(columns: gridItem,alignment: .leading) {
                ForEach(myPageSettingList) { list in
                    MyPageViewRow(settingList: list)
                }
            }
            .padding(.leading, 30)
            .padding(.top, 30)
        }
    }
}

struct MyPageView_Previews: PreviewProvider {
    static var previews: some View {
        MyPageView()
    }
}
