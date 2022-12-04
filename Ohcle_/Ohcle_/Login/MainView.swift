//
//  LoginSuccessView.swift
//  Ochle
//
//  Created by Do Yi Lee on 2022/09/30.
//

import SwiftUI

struct MainView: View {
    @StateObject var pageState: MyPageType = MyPageType.init()
    
    var body: some View {
        TabView {
            ZStack {
                Color.init("DiaryBackgroundColor")
                    .ignoresSafeArea(.all)
            }
            .tabItem {
                Image("tabItem_home")
            }
            
            NavigationStack {
                switch pageState.pageType {
                case .calender :
                    Calender()
                        .environmentObject(pageState)
                case .location :
                    ClimbingLocation()
                        .environmentObject(pageState)
                case .score:
                    ClimbingScore()
                        .environmentObject(pageState)
                case .level:
                    Level()
                        .environmentObject(pageState)
                case .review:
                    MemoView()
                        .environmentObject(pageState)
                }
            }
//            NavigationStack(path: $pathState.path) {
//

//                Calender(path: $pathState.path, nextPageType: .init())
//                    .toolbar {
//                        ToolbarItem(placement: .navigationBarTrailing) {
//                            NavigationLink {
//                                ClimbingLocation(path: $pathState.path)
//                            } label: {
//                                Text("다음")
//                                    .font(.title3)
//                                Image(systemName: "paperplane")
//                                    .padding(.trailing, 10)
//                            }
//                            .foregroundColor(.black)
//                        }
//                    }
//            }
          
            .tabItem {
                Image("tabItem_plus")
            }
            Text("세번째")
                .tabItem {
                    Image("tabItem_self")
                }
        }.background(Color.white)
    }
}


struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
