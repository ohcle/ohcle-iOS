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


struct DiaryList: View {
    private let listSpacing: CGFloat = 30
    
    private let column = [
        GridItem(.flexible(minimum: 250))
    ]
    
    @State private var isPresented: Bool = false
    @State private var switchWehnMemoChanged: Bool = false
    @State var selectedDiaryIndex: Int = .zero
    
    @State private var isSelected: Bool = false
    @State private var isDismissed: Bool = true
    @ObservedObject var calenderData: CalenderViewModel
    @State private var isModal: Bool = false
    @State private var diaryID: Int = 0
    
    var body: some View {
        ZStack (alignment: .top){
            VStack(spacing: listSpacing) {
                DiaryHeader(year: calenderData.year,
                            month: calenderData.month,
                            isDismissed: $isDismissed)
                .padding(.top, 10)
                
                //                if calenderData.data.flatMap { record in
                //                    record.values.compactMap { $0 }}?.count == .zero {
                //                    VStack {
                //                        Image("DiaryListDefault")
                //                            .padding(.top, 100)
                //                        Spacer()
                //                        
                //                    }
                //                } else {
                //                    ScrollView(.vertical) {
                //                        LazyVGrid(columns: column, alignment: .leading, spacing: listSpacing) {
                //                            ForEach(calenderData.newData) { calenderViewModel in
                //                                DiaryListViewGridItem(
                //                                    date: calenderViewModel.when,
                //                                    location: calenderViewModel.where?.name,
                //                                    levelColor: calenderViewModel.level,
                //                                    score: Int16(calenderViewModel.score),
                //                                    memoImageData: calenderViewModel.thumbnail
                //                                )
                //                                .onTapGesture {
                //                                    diaryID = calenderViewModel.id
                //                                    isModal = true
                //                                }
                //                            }
                //                        }
                //                        .padding(.leading, 20)
                //                    }
                ////                    
                //                    ScrollView(.vertical) {
                //                        LazyVGrid(columns: column, alignment: .leading, spacing: listSpacing) {
                //                            ForEach(calenderData.data) { calenderViewModel in
                //                                DiaryListViewGridItem(
                //                                    date: calenderViewModel.when,
                //                                    location: calenderViewModel.where?.name,
                //                                    levelColor: calenderViewModel.level,
                //                                    score: Int16(calenderViewModel.score),
                //                                    memoImageData: calenderViewModel.thumbnail
                //                                )
                //                                .onTapGesture {
                //                                    diaryID = calenderViewModel.id
                //                                    isModal = true
                //                                }
                //                            }
                //                        }
                //                        .padding(.leading, 20)
                //                    }
                //                    
                
                
                
                // DiaryList
                //                    ScrollView(.vertical) {
                //                        LazyVGrid(columns: column,
                //                                  alignment: .leading,
                //                                  spacing: listSpacing) {
                //                            
                //                            ForEach($calenderData.newData.flatMap { $0.value.values.compactMap { $0 } }.sorted { $0.when > $1.when }) { calenderViewModel in
                //                                
                //                                DiaryListViewGridItem(date: calenderViewModel.when,
                //                                                      location: calenderViewModel.where?.name,
                //                                                      levelColor: calenderViewModel.level ,
                //                                                      score: Int16(calenderViewModel.score),
                //                                                      memoImageData: calenderViewModel.thumbnail)
                //                                .onTapGesture {
                //                                    diaryID = calenderViewModel.id
                //                                    isModal = true
                //                                }
                //                            }
                //                        }
                //                                  .padding(.leading, 20)
                //                        // End Of LazyVGrid
                //                    }
                //                }
                //            }
                if !self.isDismissed {
                    withAnimation {
                        DateFilterView(currentYear: Int(OhcleDate.currentYear ?? "2023") ?? 2023,
                                       isSelected: $isSelected,
                                       isDismissed: $isDismissed,
                                       calenderData: calenderData)
                        .frame(minWidth: 250, idealWidth: 250,
                               maxWidth: 250, minHeight: 250,
                               idealHeight: 250, maxHeight: 250,
                               alignment: .center)
                        .background(Color.white)
                        .padding(.top, 55)
                    }
                }
            }
            .sheet(isPresented: $isModal) {
                NewMemoView(isModalView: $isModal,
                            isMemoChanged: $calenderData.switchWhenMemoChanged,
                            id: $diaryID)
            }
        }
    }
    
    private func removeRows(_ id: Int) {
        for weekDict in calenderData.data {
            for dayDict in weekDict.value {
                let obj = dayDict.value
                if obj.id == id {
                    calenderData.data[weekDict.key]?.removeValue(forKey: dayDict.key)
                    
                }
            }
        }
    }
}
