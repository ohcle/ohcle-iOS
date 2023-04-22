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
    let content: () -> Content
    
    init(title: String, color: Color, content: @escaping () -> Content) {
        self.title = title
        self.color = color
        self.content = content
    }
    
    var body: some View {
        ZStack {
            Button {
                content()
            } label: {
                ZStack {
                    Text(title)
                        .foregroundColor(.black)
                    Circle()
                        .foregroundColor(color)
                        .opacity(0.2)
                }
            }
        }
    }
}


struct CircleDateView_Previews: PreviewProvider {
    static var previews: some View {
        CircleDate<Void>(title: "2023", color: .gray) {
            
        }
    }
}
