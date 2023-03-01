//
//  DiaryHeader.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2022/11/12.
//

import SwiftUI


struct DiaryHeader: View {
    var body: some View {
        VStack {
            HStack {
                Text(OhcleDate.currentDate)
                    .font(.title)
                    .padding(.bottom, 10)
                Image(systemName: "arrow")
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
