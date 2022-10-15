//
//  Calender.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2022/10/09.
//

import SwiftUI


struct Calender: View {
    @State private var date = Date()
    
    var body: some View {
        ZStack {
            VStack{
                Text("언제 클라이밍 하셨나요?")
                    .font(.title)
                            
                DatePicker(
                    "", selection: $date,
                    displayedComponents: [.date]
                )
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
