//
//  DiaryTabBar.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2022/10/15.
//

import SwiftUI

struct DiaryTabBar: View {
    @State private var commonSize = CGSize()
    
    var body: some View {
        TabView {
            Calender()
                .tabItem {
                    Image("tabItem_plus")
                }
            Text("두번째")
                .tabItem {
                    Image("tabItem_home")
                }
            Text("세번째")
                .tabItem {
                    Image("tabItem_self")
                }
        }.background(Color.white)
    }
}

struct DiaryTabBar_Previews: PreviewProvider {
    static var previews: some View {
        DiaryTabBar()
        
    }
}
