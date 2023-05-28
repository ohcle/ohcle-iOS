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
    @State private var isEdited: Bool = true
    @State var selectedDiaryIndex: Int = .zero
//    @State var calenderList: [CalenderViewModel] = []
//    @State var date: Date = Date()
    @State private var isSelected: Bool = false
    @State private var isDismissed: Bool = true
    @ObservedObject var calenderData: CalenderData = CalenderData()
    @State private var isModal: Bool = false
    @State private var diaryID:Int = 0
    
    
    
    var body: some View {
        VStack(spacing: listSpacing) {
            DiaryHeader(year: calenderData.year, month: calenderData.month)
                .onTapGesture {
                    self.isDismissed = false
                }

            
            ZStack (alignment: .top){
                if calenderData.data.flatMap{ $0.value.values.compactMap { $0 }}.count == 0 {
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
                            ForEach(calenderData.data.flatMap{ $0.value.values.compactMap { $0 } }.sorted { $0.when > $1.when }) { calenderViewModel in

                                
                                DiaryListViewGridItem(date: calenderViewModel.when, location: calenderViewModel.where?.name, levelColorName: "gray" , score: Int16(calenderViewModel.score), memoImageData: calenderViewModel.thumbnail)
                                    .onTapGesture {
                                        diaryID = calenderViewModel.id
                                        isModal = true
                                    }
                            }
                            
                        } // End Of LazyVGrid
                        
                    }
                }
                
                
                if !self.isDismissed {
                    withAnimation {
                        DateFilterView(currentYear: Int(OhcleDate.currentYear ?? "2023") ?? 2023, isSelected: $isSelected, isDismissed: $isDismissed, calenderData: calenderData)
                            .frame(width: 250, height: 250, alignment: .center)
                            .background(Color.white)
                            .padding(.top, 20)
                        
                        
                    }
                }
                
            }
        }
        .sheet(isPresented: $isModal) {
            NewMemoView(isModalView: $isModal,
                        id: $diaryID)
        }
        
    }
    
    func removeRows(at offsets: IndexSet) {
        var rows = calenderData.data.flatMap{ $0.value.values.compactMap { $0 } }.sorted { $0.when > $1.when }
        
        let idx = Int(offsets.first ?? 0)
        print(rows[idx].id)
    
        for week in calenderData.data {
            for day in week.value {
                print(day)
                if rows[idx].id == day.value.id {
                    let weekInt = week.key
                    let dayInt = day.key
                    calenderData.data[weekInt]?.removeValue(forKey: dayInt)
                }
            }
        }
        
        RecNetworkManager.shared.deleteClimbing(id: rows[idx].id)
    }
}



//struct example_Previews: PreviewProvider {
//    static var previews: some View {
//        DiaryList(selectedDiaryIndex: 1)
//    }
//}
