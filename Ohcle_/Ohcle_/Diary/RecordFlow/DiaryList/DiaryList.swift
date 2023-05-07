//
//  DiaryList.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2022/11/12.
//

import SwiftUI

struct RecordedMemo:Identifiable {
    var id: Int
    
    let date: String?
    let location:String?
    let level: String?
    let score: Int16?
    let imageData: Data?
    let memo: String?
}

class DiaryModel: ObservableObject {
    @Published var recoredMemos = [RecordedMemo]()
    
    var orderedNum = 0
    
    init() {
        for recorededMemo in DataController.shared.fetch() {
            let recorededEle = RecordedMemo.init(id: orderedNum ,date: recorededMemo.date, location: " ", level: recorededMemo.level, score: recorededMemo.score, imageData: recorededMemo.photo, memo: recorededMemo.memo)
            recoredMemos.append(recorededEle)
            orderedNum += 1
        }
    }
    
    func fetch() {
        recoredMemos.removeAll()
        for recorededMemo in DataController.shared.fetch() {
            let recorededEle = RecordedMemo.init(id: orderedNum, date: recorededMemo.date, location: " ", level: recorededMemo.level, score: recorededMemo.score, imageData: recorededMemo.photo, memo: recorededMemo.memo)
            recoredMemos.append(recorededEle)
        }
    }
    
    func count() -> Int {
        return recoredMemos.count
    }
}

struct DiaryList: View {
    private let listSpacing: CGFloat = 30
    
    private let column = [
        GridItem(.flexible(minimum: 250))
    ]
    @ObservedObject var diaryModel = DiaryModel()
    
    @State private var isPresented: Bool = false
    @State private var isEdited: Bool = true
    @State var selectedDiaryIndex: Int = .zero
    
    var body: some View {
        VStack(spacing: listSpacing) {
            DiaryHeader()
            ZStack {
                if diaryModel.count() == 0 {
                    // DefaultImageView
                    VStack {
                        Image("DiaryListDefault")
                            .padding(.top, 100)
                        Spacer()
                    }
                } else {
                    // DiaryList
                    ScrollView(.vertical) {
                        
                        LazyVGrid(columns: column,
                                  alignment: .leading,
                                  spacing: listSpacing) {
                            ForEach(diaryModel.recoredMemos) { recoredMemo in
                                
                                DiaryListViewGridItem(date: recoredMemo.date, location: " ", levelColorName: recoredMemo.level ?? "gray", score: recoredMemo.score, memoImageData: recoredMemo.imageData)
                            }
                        }
                                  .padding(.leading, 20)
                                  .padding(.trailing, 20)
                        // End Of LazyVGrid
                    }
                }
            }
        }
        .task {
            await CalendarDataManger.shared.getData(year: "2023", month: "03")
            calenderList = CalendarDataManger.shared.calenderList
        }
    }
}

struct example_Previews: PreviewProvider {
    static var previews: some View {
        DiaryList(selectedDiaryIndex: 1)
    }
}
