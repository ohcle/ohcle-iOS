//
//  DiaryHeader.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2022/11/12.
//

import SwiftUI


struct DiaryHeader: View {
    var year: String = OhcleDate.currentYear ?? "2023"
    var month: String = OhcleDate.currentMonthString ?? "04"
    var body: some View {
        VStack {
            HStack {
                Text("\(year)년 \(month)월")
                    .font(.title)
                    .padding(.bottom, 10)
                Image(systemName: "chevron.down")
            }
            Divider()
                .frame(minHeight: 1)
                .overlay(Color.black)
                .padding(.leading, 20)
                .padding(.trailing, 20)
        }
    }
}


struct DiaryHeader_Previews: PreviewProvider {
    static var previews: some View {
        DiaryHeader()
    }
}
