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
    @Binding var isDismissed: Bool
    
    var body: some View {
        VStack {
            HStack {
                Text("\(year)년 \(month)월")
                    .font(.title)
                    .padding(.bottom, 10)
                Button {
                    self.isDismissed.toggle()
                } label: {
                    Image(systemName: "chevron.down")
                        .foregroundColor(.black)
                }
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
    @State static var isdismissed = true
    static var previews: some View {
        DiaryHeader(isDismissed: $isdismissed)
    }
}
