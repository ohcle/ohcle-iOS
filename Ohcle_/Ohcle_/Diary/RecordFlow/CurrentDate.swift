//
//  CurrentDate.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2023/01/23.
//

import Foundation

public let currentDate: String = {
    let currentDate = Date()
    let formatter = DateFormatter()
    
    formatter.timeStyle = .none
    formatter.dateStyle = .medium
    formatter.locale = Locale(identifier: "ko")
    formatter.setLocalizedDateFormatFromTemplate("yyyy MMMM")
    return formatter.string(from: currentDate)
}()
