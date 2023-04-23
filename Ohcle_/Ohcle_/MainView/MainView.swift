//
//  LoginSuccessView.swift
//  Ochle
//
//  Created by Do Yi Lee on 2022/09/30.
//

import SwiftUI
import UIKit

struct RecordView: View {
    @ObservedObject var currentPageState: MyPageType
    @Binding var selectedPage: Int
    @State var isEdited: Bool = false
    
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
            Calender()
                .environmentObject(currentPageState)
        }
    }
}

struct MainView: View {
    @StateObject var pageState: MyPageType = MyPageType.init()
    @State private var selectedPage = 0
    var calenderData: CalenderData = CalenderData()

    init() {
        UIPageControl.appearance().currentPageIndicatorTintColor =  UIColor(named: "HomeCurIndicatorColor")
        UIPageControl.appearance().pageIndicatorTintColor = UIColor(named: "HomeIndicatorColor")
        UIPageControl.appearance().isUserInteractionEnabled = false
    }

    var body: some View {
        TabView {
            TabView {
                CalenderView()
                    .environmentObject(calenderData)
                DiaryList()
                    .environmentObject(calenderData)
            }
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .always))
            .tabItem {
                Image("tabItem_home")
            }
            
            NavigationView {
                RecordView(currentPageState: pageState, selectedPage: $selectedPage)
            }
            .tabItem {
                Image("tabItem_plus")
            }
            
            MyPageView()
                .tabItem {
                    Image("tabItem_self")
                }
        }
    }
}


struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
