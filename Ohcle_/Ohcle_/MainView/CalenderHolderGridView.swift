//
//  ClimbingClander.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2023/01/23.
//

import SwiftUI

enum HolderLocatedType: CaseIterable {
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

enum HolderColorNumber: String {
    case red = "1"
    case orange = "2"
    case yellow = "3"
    case green = "4"
    case blue = "5"
    case indigo = "6"
    case purple = "7"
    case black = "8"
    case white = "9"
    case gray = "10"
    case nonSelected = "11"
}

struct HolderType {
    let holder: Image
    let holderShape : String?
    let holderID: Int
    
    init(holderID: Int = 10, holderColor: HolderColorNumber,
         _ holderShape: HolderShapeAssetNumber?) {
        let divider = "-"
        let colorName = holderColor.rawValue
        let holderShape = HolderShapeAssetNumber.allCases.randomElement() ?? .five
        let holderTypeAssetName = holderShape.rawValue
        let assetName = holderTypeAssetName + divider + colorName
        
        self.holderID = holderID
        self.holderShape = holderShape.rawValue
        self.holder = Image(assetName)
    }
    
    
    init(holderID: Int = 10, holderColor: HolderColorNumber,
         holderShape: HolderShapeAssetNumber) {
        let holderTypeAssetName = holderShape.rawValue
        let divider = "-"
        let colorName = holderColor.rawValue
        let assetName = holderTypeAssetName + divider + colorName
        
        self.holderID = holderID
        self.holderShape = holderShape.rawValue
        self.holder = Image(assetName)
    }
    
    enum HolderShapeAssetNumber: String, CaseIterable {
        case one = "1"
        case two = "2"
        case four = "4"
        case five = "5"
        case six = "6"
        case nine = "9"
        case thirteen = "13"
        case twentyOne = "21"
        case twentyTwo = "22"
        case twentyThree = "23"
        case twentyFive = "25"
    }
}

struct CalenderHolderGridView: View {
    let isClimbedDate: Bool
    let holderType: HolderType?

    private let holderLocatedType: HolderLocatedType = .allCases.randomElement() ?? .big
    private let backgroundColor = Color("holder_background")
    private let widthHeightRatio: CGFloat = 5/4
    private let widthRatio: CGFloat = 2/16
    
    init(isClimbedDate: Bool = false, holderType: HolderType?) {
        self.isClimbedDate = isClimbedDate
        self.holderType = holderType
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(backgroundColor)
                .frame(width: UIScreen.screenWidth * widthRatio, height: UIScreen.screenWidth * widthRatio * widthHeightRatio)
            Image(self.holderLocatedType.typeImageString)
            if self.isClimbedDate {
                self.holderType?.holder
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: UIScreen.screenWidth * widthRatio * (4/5))
            }
        }
    }
}

