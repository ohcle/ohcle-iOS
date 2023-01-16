//
//  DiaryList.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2022/11/12.
//

import SwiftUI

struct DiaryList: View {
//    private let currentDate: String = {
//        let currentDate = Date()
//        let formatter = DateFormatter()
//
//        formatter.timeStyle = .none
//        formatter.dateStyle = .medium
//        formatter.locale = Locale(identifier: "ko")
//        formatter.setLocalizedDateFormatFromTemplate("yyyy MMMM")
//        return formatter.string(from: currentDate)
//    }()
//
    let colums : [GridItem] = [
        GridItem(.fixed(50), spacing: nil, alignment: nil),
        GridItem(.fixed(50), spacing: nil, alignment: nil)
    ]
    
    var body: some View {
        GeometryReader { geometry in
            DiaryHeader()
            
        }
    }
}

struct DiaryList_Previews: PreviewProvider {
    static var previews: some View {
        DiaryList()
    }
}
