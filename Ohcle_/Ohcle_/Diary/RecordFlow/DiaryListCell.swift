//
//  DiaryListCell.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2022/12/08.
//

import SwiftUI

struct DiaryListImageGridItem: View {
    private let placeHoldeImage = Image("main_logo")
    
    var body: some View {
        GeometryReader { geometry in
            self.placeHoldeImage
                .resizable()
                .frame(width: geometry.size.width * (1/3),
                       height: geometry.size.width * (1/3))
                .padding(.trailing, 10)
        }
    }
}

struct DiaryListCell_Previews: PreviewProvider {
    static var previews: some View {
        DiaryListImageGridItem()
    }
}
