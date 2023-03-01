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
        case .done:
            MemoView().environmentObject(currentPageState)
        }
    }
}

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
