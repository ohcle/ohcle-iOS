//
//  ClimbingClander.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2023/01/23.
//

import SwiftUI

enum HolderLocatedType {
    case big
    case small
    
    var typeImageString: String {
        switch self {
        case .big:
            return "calender_holder_back_big"
        case .small:
            return "calender_holder_back_small"
        }
    }
}

struct HolderType {
    let color: Color
    let date : String
    let holderShape : HolderShape
}

enum HolderShape: String {
    case red_1 = "calender_holder_red_1"
    case red_2 = "calender_holder_red_2"
    case red_3 = "calender_holder_red_3"
}

struct CalenderHolderGridView: View {
    @Binding var isClimbedDate: Bool

    let holderLocatedType: HolderLocatedType
    let holderType: HolderType
    private let backgroundColor = Color("holder_background")
    private let widthHeightRatio: CGFloat = 5/4
    private let widthRatio: CGFloat = 2/16

    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(backgroundColor)
                .frame(width: UIScreen.screenWidth * widthRatio, height: UIScreen.screenWidth * widthRatio * widthHeightRatio)
            Image(self.holderLocatedType.typeImageString)
            if self.isClimbedDate {
                Image("calender_holder_red_1")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: UIScreen.screenWidth * widthRatio * (4/5))
            }
        }
    }
}
//
//struct ClimbingClander_Previews: PreviewProvider {
//    @State var test: Bool = true
//    static var previews: some View {
//        CalenderHolderGridView(holderLocatedType: .big, holderType: HolderType(color: .blue, date: "2222", holderShape: HolderShape.red_1), isClimbed: test)
//    }
//}
