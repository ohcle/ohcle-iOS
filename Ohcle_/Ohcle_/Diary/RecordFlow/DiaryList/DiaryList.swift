//
//  DiaryList.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2022/11/12.
//

import SwiftUI

struct RecordedMemo: Hashable {
    let date: String
    let location:String
    let level: String
    let score: String
    let image: String
    let id: UUID
}

struct DiaryList: View {
    private let listSpacing: CGFloat = 30
    let memos: [RecordedMemo] = [
        RecordedMemo(date: "2022.01.22", location: "더클 양재", level: "빨강", score: "4.5", image: "main-logo", id: UUID()),
        RecordedMemo(date: "2022.01.23", location: "더클 연남", level: "노랑", score: "2.0", image: "main-logo", id: UUID()),
        RecordedMemo(date: "2022.01.23", location: "더클 서울대", level: "노랑", score: "2.0", image: "main-logo", id: UUID()),
        RecordedMemo(date: "2022.01.23", location: "더클 수원", level: "노랑", score: "2.0", image: "main-logo", id: UUID())
    ]
        
    private let column = [
        GridItem(.flexible(minimum: 250))
    ]

    var body: some View {
        VStack(spacing: listSpacing) {
            DiaryHeader()
            ScrollView(.vertical) {
                LazyVGrid(columns: column,
                          alignment: .leading,
                          spacing: listSpacing) {
                    ForEach(memos, id: \.self) { memo in
                        DiaryListViewGridItem(date: memo.date,
                                              location: memo.location,
                                              level: memo.level,
                                              score: memo.score,
                                              memoImageName: memo.image)
                        .padding(.leading, 30)
                    }
                }
            }
        }
    }
}
struct example_Previews: PreviewProvider {
    static var previews: some View {
        DiaryList()
    }
}
