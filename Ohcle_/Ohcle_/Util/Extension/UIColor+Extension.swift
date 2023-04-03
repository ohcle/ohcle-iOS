//
//  UIColor+Extension.swift
//  Ohcle_
//
//  Created by yeongbin ro on 2023/04/03.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(_ hexString: String, alpha: CGFloat = 1.0) {
        let scanner = Scanner(string: hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted))
        var hexNumber: UInt64 = 0
        if scanner.scanHexInt64(&hexNumber) {
            self.init(
                red: CGFloat((hexNumber & 0xff0000) >> 16) / 255.0,
                green: CGFloat((hexNumber & 0x00ff00) >> 8) / 255.0,
                blue: CGFloat(hexNumber & 0x0000ff) / 255.0,
                alpha: alpha
            )
        } else {
            self.init(red: 0.0, green: 0.0, blue: 0.0, alpha: alpha)
        }
    }
}

