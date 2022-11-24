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
        HStack(alignment: .center) {
            Image(settingList.iconImageString)
                .padding(.trailing, 10)
            Text(settingList.title)
        }
    }
}

struct MyPageView: View {
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
        List(myPageSettingList) {
            MyPageViewRow(settingList: $0)
                .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
    }
}

struct MyPageView_Previews: PreviewProvider {
    static var previews: some View {
        MyPageView()
    }
}
