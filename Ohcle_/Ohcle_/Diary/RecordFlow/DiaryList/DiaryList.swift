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
    let score: Int16
    let imageData: Data
}

struct DiaryList: View {
    private let listSpacing: CGFloat = 30

    private let column = [
        GridItem(.flexible(minimum: 250))
    ]
    
    @FetchRequest(entity: Diary.entity(), sortDescriptors: []) var diaries: FetchedResults<Diary>
    @State private var isPresented: Bool = false
    
    var body: some View {
        VStack(spacing: listSpacing) {
            DiaryHeader()
            ScrollView(.vertical) {
                LazyVGrid(columns: column,
                          alignment: .leading,
                          spacing: listSpacing) {
                    ForEach(diaries, id: \.self) { diary in
                        DiaryListViewGridItem(date: diary.date, location:
                                                "", levelColorName: diary.lavel ?? "gray", score: diary.score, memoImageData: diary.photo)
                        .sheet(isPresented: $isPresented, content: {
                            MemoView()
                        })
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
