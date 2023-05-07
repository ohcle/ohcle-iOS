//
//  RefacotCalenderView.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2023/05/04.
//

import SwiftUI

struct RefacotCalenderView: View {
    @State private var isSelected: Bool = false
    @State private var isDismissed: Bool = true
    @State private var isModal: Bool = true
    
    @ObservedObject var calenderData: CalenderData = CalenderData()
    
    var body: some View {
        ZStack {
            VStack {
                UpperBar()
                Spacer()
                CalenderMiddleView(yearString: self.calenderData.year, monthString: self.calenderData.month) {
                    self.isDismissed = false
                }
                
                CalenderHolderView(calenderData: calenderData)
                
                Spacer()
            }
            
            if !self.isDismissed {
                withAnimation {
                    DateFilterView(currentYear: 2023, isSelected: $isSelected, isDismissed: $isDismissed, calenderData: calenderData)
                        .frame(width: 250, height: 250, alignment: .center)
                        .background(Color.white)
                        .padding(.top, 20)
                }
            }
        }
    }
    
    private func generateRandomHolderBackground(_ typeNumber: Int) -> HolderLocatedType {
        if typeNumber == .zero {
            return HolderLocatedType.big
        } else {
            return HolderLocatedType.small
        }
    }
}

struct MemoContainer {
    
}

struct CalenderHolderView: View {
    @ObservedObject var calenderData: CalenderData
    @State private var isModal: Bool = false
    @State private var diaryID: Int? = nil
    
    var body: some View {
        VStack(spacing: 0) {
            let data = calenderData.data
            ForEach(1...5, id:\.self) { week in
                HStack(spacing: 0) {
                    ForEach(1...7, id: \.self) { date in
                        if (data[week]?[date] != nil) {
                            let level = data[week]?[date]?.level ?? 11
                            
                            let holderColor: HolderColorNumber = HolderColorNumber(rawValue: "\(level)") ?? .red
                            
                            let holderType = HolderType( holderColor: holderColor, nil)
                            
                            CalenderHolderGridView(isClimbedDate: true, holderType: holderType)
                                .onTapGesture {
                                    self.diaryID = data[week]?[date]?.id ?? 0
                                    print(data[week]?[date]?.id)
                                    self.isModal = true
                                }
                                .sheet(isPresented: $isModal) {
                                    if let diaryID = diaryID {
                                        NewMemoView(isModalView: $isModal, id: diaryID)
                                    } else {
                                        NewMemoView(isModalView: $isModal, id: diaryID ?? 21)
                                    }
                                }
                        } else {
                            CalenderHolderGridView(holderType: nil)
                                .onTapGesture {
                                    
                                }
                        }
                    }
                }
                .onChange(of: calenderData.data) { newData in
                    if let weekData = newData[1], let dateData = weekData[1] {
                        self.diaryID = dateData.id
                    } else {
                        self.diaryID = .zero
                    }
                }
                
                
            }
        }
    }
}

struct CalenderMiddleView<Content>: View {
    let content: () -> Content
    let title: String
    var yearString: String
    var monthString: String
    
    init(title: String = "클라이밍 히스토리",
         yearString: String,
         monthString: String,
         content: @escaping () -> Content) {
        self.title = title
        self.yearString = yearString
        self.monthString = monthString
        self.content = content
    }
    
    var body: some View {
        Text(title)
            .font(.title)
            .padding(.bottom, 10)
        
        Button {
            content()
        } label: {
            VStack {
                Text("\(yearString)")
                    .foregroundColor(.gray)
                Text("\(monthString)")
                    .font(.system(size: 50))
                    .foregroundColor(.black)
            }
        }
    }
}

struct RefacotCalenderView_Previews: PreviewProvider {
    static var previews: some View {
        RefacotCalenderView()
    }
}
