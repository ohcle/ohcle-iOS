//
//  ClimbingRecord.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 3/28/24.
//

import Foundation

//MARK: - Domain Layer - Entity (사용자에게 보여줄 데이터)
struct MonthRecordEntity {
    typealias DividedRecord = [WeekOfTheMonth.RawValue:
                                    [DayNumber.RawValue: ClimbingRecord]]
    
    let dividedMonthRecord: DividedRecord

    init(monthRecord: ClimbingMonthRecord) {
        let calendar = Calendar(identifier: .gregorian)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "kr")
        
        var dividedMonthRecord: DividedRecord = [WeekOfTheMonth.first.intLiteral: [:],
                                                      WeekOfTheMonth.second.intLiteral: [:],
                                                      WeekOfTheMonth.third.intLiteral: [:], WeekOfTheMonth.fourth.intLiteral: [:],
                                                      WeekOfTheMonth.fitth.intLiteral:  [:], WeekOfTheMonth.sixth.intLiteral: [:]]
        
        
        monthRecord.list.forEach { record in
            //MARK: Chnage to Date Type
            let dateString = record.date
            let date = dateFormatter.date(from: dateString) ?? Date()
            
            //MARK: Get what week is the date included
            let weekOfMonth = calendar.component(.weekOfMonth, from: date)
            let dayOfWeek: DayNumber.RawValue = getDayOfWeek(dateString: dateString)
            
            //MARK: Matching week and date number with record data
            dividedMonthRecord[weekOfMonth]?.updateValue(record, forKey: dayOfWeek)
        }
                
        self.dividedMonthRecord = dividedMonthRecord
    }
    
    enum WeekOfTheMonth: Int {
        case first = 1
        case second, third, fourth, fitth, sixth
        
        var intLiteral: Int {
            return self.rawValue
        }
    }
    
    enum DayNumber: Int {
        case Mon, Tue, Thur, Fri, Sat, Sun
        
        var intLiteral: Int {
            return self.rawValue
        }
    }
}
