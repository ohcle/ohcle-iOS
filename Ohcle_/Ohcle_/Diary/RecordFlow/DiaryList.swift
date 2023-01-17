//
//  DiaryList.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2022/11/12.
//

import SwiftUI

struct DiaryList: View {
    let colums : [GridItem] = [
        GridItem(.fixed(50), spacing: nil, alignment: nil),
        GridItem(.fixed(100), spacing: nil, alignment: nil)
    ]
    
    var body: some View {
        GeometryReader { geometry in
            DiaryHeader()
            ScrollView {
                LazyVGrid(columns: colums) {
                    
                }
            }
        }
    }
}

struct DiaryList_Previews: PreviewProvider {
    static var previews: some View {
        DiaryList()
    }
}
