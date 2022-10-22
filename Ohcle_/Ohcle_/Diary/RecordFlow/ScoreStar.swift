//
//  ScoreStar.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2022/10/22.
//

import SwiftUI

struct ScoreStar: View {
    @State private var isTouched: Bool = false
    
    var body: some View {
        Button {
            self.isTouched.toggle()
        } label: {
            if self.isTouched {
                Image("score-star")
            } else {
                Image("score-emptystar")
            }
        }
    }
}

struct ScoreStar_Previews: PreviewProvider {
    static var previews: some View {
        ScoreStar()
    }
}
