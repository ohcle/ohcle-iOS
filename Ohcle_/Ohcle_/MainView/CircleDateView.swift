//
//  CircleDateView.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2023/04/22.
//

import SwiftUI

struct CircleDate : View {
    @State var isTapped: Bool = false

    let title: String
    let color: Color
    let touchedColor: Color
    let content: () -> ()
    
    var body: some View {
        ZStack {
            Button {
                content()
                self.isTapped.toggle()
            } label: {
                ZStack {
                    Circle()
                        .foregroundColor(isTapped ? touchedColor : color)
                    Text(title)
                        .foregroundColor(.black)
                }
            }
            
        }
    }
}


struct CircleDateView_Previews: PreviewProvider {
    @State static var isPressed: Bool = true

    static var previews: some View {
        CircleDate(isTapped: isPressed, title: "2023", color: .gray, touchedColor: .orange, content: {
            
        })
    }
}
