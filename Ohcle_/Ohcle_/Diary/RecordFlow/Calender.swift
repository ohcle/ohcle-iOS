//
//  Calender.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2022/10/09.
//

import SwiftUI

enum NewMemoPageType {
    case calender
    case location
    case score
    case level
    case review
}

class MyPageType: ObservableObject {
    @Published var pageType: NewMemoPageType = .calender
}

struct Calender: View {
    @State private var date = Date()
    @State private var pickerWidth: CGFloat = 0
    @State private var pickerHeight: CGFloat = 0
    @EnvironmentObject var nextPageType: MyPageType
    
    var body: some View {
        VStack{
            Text("기록하고 싶은 날")
                .font(.title)
            
            DatePicker(
                "", selection: $date,
                displayedComponents: [.date]
            )
            .onChange(of: date, perform: { newValue in
                //Save Date Info
                //Inform changing
                self.nextPageType.pageType = .location
            })
            .readSize(onChange: { size in
                self.pickerWidth = size.width
                self.pickerHeight = size.height
            })
            .labelsHidden()
            .datePickerStyle(.wheel)
            .environment(\.locale, Locale(identifier: "ko"))
        }
    }
}

struct Calender_Previews: PreviewProvider {
    @State static var path = NavigationPath()
    static var previews: some View {
        Calender(nextPageType: .init())
    }
}
