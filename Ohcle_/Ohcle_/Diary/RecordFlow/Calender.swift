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
    case photo
    case level
    case memo
    case done
}

class MyPageType: ObservableObject {
    @Published var type: NewMemoPageType = .calender
}

struct Calender: View {
    @State private var date = Date()
    @State private var pickerWidth: CGFloat = 0
    @State private var pickerHeight: CGFloat = 0
    
    private var nextButton: NextPageButton =  NextPageButton(title: "다음 페이지로",
                                                     width: UIScreen.screenWidth/1.2,
                                                             height: UIScreen.screenHeight/15)
    
    init() {
        self.nextButton.userEvent.inform()
    }
    
    var body: some View {
        VStack {
            Text("기록하고 싶은 날")
                .font(.title)
            
            DatePicker(
                "", selection: $date,
                displayedComponents: [.date]
            )

            .readSize(onChange: { size in
                self.pickerWidth = size.width
                self.pickerHeight = size.height
            })
            .labelsHidden()
            .datePickerStyle(.wheel)
            .environment(\.locale, Locale(identifier: "ko"))
        }
        .overlay(
            self.nextButton
                .offset(CGSize(width: 0, height: UIScreen.screenHeight/4))
        
        )
    }
}

struct Calender_Previews: PreviewProvider {
    @State static var path = NavigationPath()
    static var previews: some View {
        Calender()
    }
}
