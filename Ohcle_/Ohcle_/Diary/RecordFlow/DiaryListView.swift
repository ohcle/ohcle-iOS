//
//  DiaryListView.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2022/10/29.
//

import SwiftUI

struct DiaryListView: View {
    private let currentDate: String = {
        let currentDate = Date()
        let formatter = DateFormatter()
        
        formatter.timeStyle = .none
        formatter.dateStyle = .medium
        formatter.locale = Locale(identifier: "ko")
        formatter.setLocalizedDateFormatFromTemplate("yyyy MMMM")
        return formatter.string(from: currentDate)
    }()
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack {
                    Text(currentDate)
                        .font(.title)
                        .padding(.bottom, 10)
                    Image(systemName: "arrow")
                }
                
                Rectangle()
                    .size(width: geometry.size.width * (8/10), height: 1)
                    .padding(.leading, geometry.size.width * (1/10))
                    .padding(.trailing, geometry.size.width * (1/10))
                
                HStack {
                    Image("main_logo")
                        .resizable()
                        .frame(width: geometry.size.width * (1/3), height: geometry.size.width * (1/3))
                        .padding(.trailing, 10)
                               
                    VStack(alignment: .leading) {
                        HStack {
                            Text("날짜 ")
                                .foregroundColor(.gray)
                                .padding(.bottom, 5)
                            Text(currentDate)
                        }
                        
                        HStack {
                            Text("장소")
                                .foregroundColor(.gray)
                            Text(" 클라임웍스 클라이밍")
                        }

                        HStack {
                            Text("레벨")                                .foregroundColor(.gray)

                            Circle()
                                .fill(.red)
                                .frame(width: 20, height: 20)
                        }
                        
                        HStack {
                            Text("점수")
                                .foregroundColor(.gray)

                            HStack(spacing: 1) {
                                Image("score-star")
                                    .resizable()
                                    .frame(width: 20, height: 19)
                                Image("score-star")
                                    .resizable()
                                    .frame(width: 20, height: 19)
                                Image("score-star")
                                    .resizable()
                                    .frame(width: 20, height: 19)
                                Image("score-star")
                                    .resizable()
                                    .frame(width: 20, height: 19)
                                Image("score-star")
                                    .resizable()
                                    .frame(width: 20, height: 19)
                            }
                        }
                    }
                }
            }
        }
    }
}

struct DiaryListView_Previews: PreviewProvider {
    static var previews: some View {
        DiaryListView()
    }
}
