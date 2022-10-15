//
//  Calender_2.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2022/10/15.
//

import SwiftUI

struct Calender_2: View {
    @Binding private var date: Date
    
    var body: some View {
        ZStack {
            VStack{
                Text("언제 클라이밍 하셨나요?")
                    .font(.title)
                            
                Picker(selection: $date) {
                    
                } label: {
                    
                }

            }
        }
    }
}

//struct Calender_2_Previews: PreviewProvider {
//    static var previews: some View {
//        Calender_2(date: <#T##Date#>)
//    }
//}
