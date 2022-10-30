//
//  Calender.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2022/10/09.
//

import SwiftUI


struct Calender: View {
    @State private var date = Date()
    @State private var pickerWidth: CGFloat = 0
    @State private var pickerHeight: CGFloat = 0

    
    
    var body: some View {
        ZStack {
            VStack{
                Text("언제 클라이밍 하셨나요?")
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
        }
    }
}

struct Calender_Previews: PreviewProvider {
    static var previews: some View {
        Calender()
    }
}
