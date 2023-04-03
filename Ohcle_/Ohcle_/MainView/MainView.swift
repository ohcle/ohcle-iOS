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

    init() {
        UIPageControl.appearance().currentPageIndicatorTintColor =  UIColor("FF9900")
        UIPageControl.appearance().pageIndicatorTintColor = UIColor("262626")
    }

    var body: some View {
        TabView {
            //1
            TabView {
                CalenderView()
                DiaryList()
            }
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .always))
            .tabItem {
                Image("tabItem_home")
            }
            
            //2
            NavigationView {
                RecordView(currentPageState: pageState, selectedPage: $selectedPage)
            }
            .tabItem {
                Image("tabItem_plus")
            }
            
            //3
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
