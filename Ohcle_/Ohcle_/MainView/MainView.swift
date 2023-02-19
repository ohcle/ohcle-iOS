//
//  LoginSuccessView.swift
//  Ochle
//
//  Created by Do Yi Lee on 2022/09/30.
//

import SwiftUI

struct RecordView: View {
    @ObservedObject var currentPageState: MyPageType
    
    var body: some View {
        switch currentPageState.type {
        case .calender :
            Calender()
                .environmentObject(currentPageState)
        case .location :
            ClimbingLocation()
                .environmentObject(currentPageState)
        case .score:
            ClimbingScore()
                .environmentObject(currentPageState)
        case .level:
            Level()
                .environmentObject(currentPageState)
        case .photo:
            AddPhotoView().environmentObject(currentPageState)
        case .memo:
            MemoView().environmentObject(currentPageState)
        case .edit:
            MemoView()
                .environmentObject(currentPageState)
        }
    }
}

// 버튼누르면 모달로 나오고 탭뷰의 버튼은 양 옆은 탭 버튼, 가운데는 일반 버튼.
// 플러스버튼이 올라가고 나머지 두 탭뷰 버튼이 이등분되는 거리로
// 오토레이아웃, 다크모드 -> 그린 QA 해봤을 사람들.
// 간격의 비율에 신경을 쓰면 컴포넌트는 크게 문제되지 않았던 것 같다.

// 1. SwiftUI 에서의 오토 레이아웃
// 비율을 이용하는건 지저분, 현업에서도 지양.
// 대부분은 피그마에서 주어진대로 작업. maxwidth등을 이용. 큰 기기로 하고 작은기기로 테스트 진행.
// 스페이서를 잘 활용하자
// 작은 요소 들을 hstack에 넣을 때 중간 요소들은 스페이서로 잡고 가장 밖 패딩만 특정해줌.

// 2. 스와이프 기능 -> 'tabview style 로 바꾸기, page indicator를 설정하면 됨.
// withanimation(////)로 뷰 간의 애니메이션 줄 수 있음

//3. 지금의 형태는 데이터피커의 휠이 멈추는 즉시 바로 뷰가 변하도록 하고 있는데 1~2초의 지연시간을 두려고 함.
// -> Debouncer...예거..

//4. 앱 피드백

struct MainView: View {
    @StateObject var pageState: MyPageType = MyPageType.init()
    
    var body: some View {
        TabView {
            TabView {
                CalenderView()
                DiaryList()
            }
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .never))
            .tabItem {
                Image("tabItem_home")
            }
            
            NavigationView {
                RecordView(currentPageState: pageState)
            }
            .tabItem {
                Image("tabItem_plus")
            }
            
            MyPageView()
                .tabItem {
                    Image("tabItem_self")
                }
        }
        .background(Color.white)
    }
}


struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
