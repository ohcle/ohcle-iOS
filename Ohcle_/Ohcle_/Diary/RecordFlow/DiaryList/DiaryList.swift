//
//  DiaryList.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2022/11/12.
//

import SwiftUI

struct RecordedMemo: Identifiable {
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
    
    @State var calenderList: [CalenderModel] = []
    
    @State var date: Date = Date()
    @State var showDatePicker = false
    
    
    
    var body: some View {
        VStack(spacing: listSpacing) {
            DiaryHeader()
                .onTapGesture {
                    showDatePicker = true
                }

            
            ZStack (alignment: .top){
                if calenderList.count == 0 {
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
                            
                            ForEach(calenderList) { calenderViewModel in
                                DiaryListViewGridItem(date: calenderViewModel.when, location: calenderViewModel.where.name, levelColorName: "gray" , score: Int16(calenderViewModel.score), memoImageData: Data())
                            }
                            
                        } // End Of LazyVGrid
                        
                    }
                }
                
                
                if showDatePicker {
                    DatePicker(
                            "",
                            selection:$date,
                            displayedComponents: [.date])
                        .datePickerStyle(GraphicalDatePickerStyle())
                        .background(.white)
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
