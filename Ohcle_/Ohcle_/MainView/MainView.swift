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
    @State var isModal: Bool = false
    @Binding var selectedTab:Int
    
    var body: some View {
        switch currentPageState.type {
        case .calender :
            Calender()
                .environmentObject(currentPageState)
        case .location :
            ClimbingLocationView()
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
            MemoView(isModal: $isModal, selectedTab: $selectedTab).environmentObject(currentPageState)
        case .done:
            Calender()
                .environmentObject(currentPageState)
        }
    }
}

struct MainView: View {
    @StateObject var pageState: MyPageType = MyPageType.init()
    @State private var selectedPage = 0
    @State var selectedTab = 1
    @ObservedObject var calenderData = CalenderData()

    init() {
        UIPageControl.appearance().currentPageIndicatorTintColor =  UIColor(named: "HomeCurIndicatorColor")
        UIPageControl.appearance().pageIndicatorTintColor = UIColor(named: "HomeIndicatorColor")
        UIPageControl.appearance().isUserInteractionEnabled = false
    }

    var body: some View {
        TabView (selection: $selectedTab){
            if ProgressManager.shared.isShowing {
                ProgressView()
            }
            TabView {
                RefactorCalenderView(calenderData: calenderData)
                DiaryList(calenderData: calenderData)
            }
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .always))
            .tabItem {
                Image("tabItem_home")
            }
            .tag(1)
            
            NavigationView {
                RecordView(currentPageState: pageState, selectedPage: $selectedPage, selectedTab: $selectedTab)
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        
                        // Right Button
                        ToolbarItem(placement:  .navigationBarTrailing) {
                            if pageState.type != .memo && pageState.type != .done {
                                Button {
                                    nextPageInRecordView(pageState)
                                } label: {
                                    Text("건너뛰기")
                                        .foregroundColor(.gray)
                                }
                            }
                            
                        }
                        
                        // Left Button
                        ToolbarItem(placement: .navigationBarLeading) {
                            if pageState.type != .calender {
                                Button {
                                    prevPageInRecordView(pageState)
                                } label: {
                                    Image(systemName: "chevron.backward")
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                    }
            }
            .tabItem {
                Image("tabItem_plus")
            }
            .tag(2)
            
            MyPageView()
            .tabItem {
                Image("tabItem_self")
            }
            .tag(3)
        }
    }
    
    
    private func nextPageInRecordView(_ currentPageState: MyPageType) {
        switch currentPageState.type {
        case .calender:
            currentPageState.type = .location
        case .location:
            currentPageState.type = .level
        case .level:
            currentPageState.type = .score
        case .score:
            currentPageState.type = .photo
        case .photo:
            currentPageState.type = .memo
        case .memo:
            return
        case .`done`:
            return
        }
        
    }
    private func prevPageInRecordView(_ currentPageState: MyPageType) {
        switch currentPageState.type {
        case .calender:
            return
        case .location:
            currentPageState.type = .calender
        case .level:
            currentPageState.type = .location
        case .score:
            currentPageState.type = .level
        case .photo:
            currentPageState.type = .score
        case .memo:
            currentPageState.type = .photo
        case .`done`:
            currentPageState.type = .photo
        }
    }
}


struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
