//
//  LoginSuccessView.swift
//  Ochle
//
//  Created by Do Yi Lee on 2022/09/30.
//

import SwiftUI

struct MainView: View {
    @State var path = NavigationPath()
    
    var body: some View {
        TabView {
            ZStack {
                Color.init("DiaryBackgroundColor")
                    .ignoresSafeArea(.all)
            }
            .tabItem {
                Image("tabItem_home")
            }
            
            NavigationStack(path: $path) {
                NavigationLink {
//                    ClimbingLocation(path: $path)
                } label: {
                   
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("이전") {
                            if path.count != .zero {
                                self.path.removeLast()
                            }
                        }.foregroundColor(.black)
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        HStack {
                            Spacer()
                            Text("다음")
                                .foregroundColor(.black)
                                .font(.title3)
                            Image(systemName: "paperplane")
                                .padding(.trailing, 10)
                        }                    }
                }
                Spacer()
                Calender()
                Spacer()
            }
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
