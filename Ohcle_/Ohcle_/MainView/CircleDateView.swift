//
//  CircleDateView.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2023/04/22.
//

import SwiftUI

struct CircleDate<Content> : View {
    let title: String
    let color: Color
    let touchedColor: Color
    let content: () -> Content
    
    init(title: String, color: Color,
         touchedColor: Color,
         content: @escaping () -> Content) {
        self.title = title
        self.color = color
        self.touchedColor = touchedColor
        self.content = content
    }
    
    @State private var isPressed = false

    var body: some View {
        ZStack {
            Button {
                content()
                isPressed.toggle()
            } label: {
                ZStack {
                    Circle()
                        .foregroundColor(isPressed ? touchedColor : color)
                    Text(title)
                        .foregroundColor(.black)
                }
            }
            .tint(touchedColor)
        }
    }
}


struct CircleDateView_Previews: PreviewProvider {
    static var previews: some View {
        CircleDate<Void>(title: "2023", color: .gray, touchedColor: Color.orange) {
            
        }
    }
}
