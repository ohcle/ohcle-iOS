//
//  DiaryList.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2022/11/12.
//

import SwiftUI

struct RecordedMemo {
    let date: String?
    let location:String?
    let level: String?
    let score: Int16?
    let imageData: Data?
    let memo: String?
}

struct DiaryList: View {
    private let listSpacing: CGFloat = 30

    private let column = [
        GridItem(.flexible(minimum: 250))
    ]
    
    @FetchRequest(entity: Diary.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \Diary.date, ascending: false)]) var diaries: FetchedResults<Diary>
    
    @State private var isPresented: Bool = false
    @State private var isEdited: Bool = true
    @State var selectedDiaryIndex: Int = .zero
    
    var body: some View {
        VStack(spacing: listSpacing) {
            DiaryHeader()
            ScrollView(.vertical) {
                LazyVGrid(columns: column,
                          alignment: .leading,
                          spacing: listSpacing) {
                    ForEach(diaries.indices) { index in
                        let diary = diaries[index]
                        DiaryListViewGridItem(date: diary.date, location:
                                                "", levelColorName: diary.level ?? "gray", score: diary.score, memoImageData: diary.photo)
                        .onTapGesture {
                            self.isPresented.toggle()
                            self.selectedDiaryIndex = index
                            
                            DataController.shared.saveTemporaryDate(diary.date ?? "")
                            DataController.shared.saveTemporaryLevel(diary.level ?? "")
                            DataController.shared.saveTemporaryScore(diary.score)
                            DataController.shared.saveTemporaryPhotoData(diary.photo ?? Data())
                            DataController.shared.saveTemporaryMemo(diary.memo ?? "")
                        }
                        .padding(.leading, 30)
                    }
                    .sheet(isPresented: $isPresented, content: {
                         MemoView(diary: diaries[selectedDiaryIndex])
                    })
                }
            }
        }
    }
}

struct example_Previews: PreviewProvider {
    static var previews: some View {
        DiaryList(selectedDiaryIndex: 1)
    }
}
