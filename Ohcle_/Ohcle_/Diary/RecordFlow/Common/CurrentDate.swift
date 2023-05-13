//
//  CurrentDate.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2023/01/23.
//

import Foundation

class OhcleDate {
    let diaryDateFormatter: DateFormatter = {
        let date = Date()
        let formatter = DateFormatter()
        
        formatter.timeStyle = .none
        formatter.dateStyle = .medium
        formatter.locale = Locale(identifier: "ko")
//        formatter.setLocalizedDateFormatFromTemplate("yyyy-MMMM dd")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    let formatter: DateFormatter = {
        let date = Date()
        let formatter = DateFormatter()
        
        formatter.timeStyle = .none
        formatter.dateStyle = .medium
        formatter.locale = Locale(identifier: "ko")
        formatter.setLocalizedDateFormatFromTemplate("yyyy MMMM")
        return formatter
    }()
    
    static let currentDate: String = {
        let date = Date()
        let formatter = DateFormatter()
        
        formatter.timeStyle = .none
        formatter.dateStyle = .medium
        formatter.locale = Locale(identifier: "ko")
        formatter.setLocalizedDateFormatFromTemplate("yyyy MMMM")
        
        return formatter.string(from: date)
    }()

    static let currentMonth: Int? = {
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.month], from: date)
        let month = components.month
        
        return month
    }()
    
    static let currentYear: String? = {
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year], from: date)
        let year = components.year
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .ordinal
        return numberFormatter.string(from: NSNumber(nonretainedObject: year))
    }()
    
    static let currentMonthString: String? = {
        let date = Date()
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.dateFormat = "MM"
        let monthString = formatter.string(from: date)

        return monthString
    }()
}
