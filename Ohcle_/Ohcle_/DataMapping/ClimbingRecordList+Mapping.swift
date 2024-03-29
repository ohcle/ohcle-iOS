//
//   MontlyClimbingResponseDTO.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 3/28/24.
//

import Foundation

// MARK: - Climbing Data Transfer Object (기존에 CalenderModel이였던 것)
struct ClimbingRecordList: Decodable {
    let climbingRecordList: [ClimbingRecord]
}

//(기존에 CalenderModel이였던 것)
struct ClimbingRecord: Decodable {
    let id: Int
    let `where`: ClimbingLocationDTO?
    let date: String
    let level: Int
    let score: Float
    let picture: [String?]?
    let thumbnail: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case `where`
        case date = "when"
        case level
        case score
        case picture
        case thumbnail
    }
    
    struct ClimbingLocationDTO: Decodable {
        let id: Int
        let name: String
        let address: String
        let latitude: Float
        let longitude: Float
    }
}

// MARK: - Mappings to Domain (실제페이지와 연결, 기존의 DividedWeekData 타입의 모델로 맵핑 필요)

extension ClimbingRecordList {
    typealias MonthRecordEntity = [WeekOfTheMonth.RawValue:
                                    [DayNumber.RawValue: ClimbingRecord]]
    
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
    
    func transformToDomin() -> MonthRecordEntity {
        let calendar = Calendar(identifier: .gregorian)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "kr")
        
        var dividedMonthRecords: MonthRecordEntity = [WeekOfTheMonth.first.intLiteral: [:],
                                                      WeekOfTheMonth.second.intLiteral: [:],
                                                      WeekOfTheMonth.third.intLiteral: [:], WeekOfTheMonth.fourth.intLiteral: [:],
                                                      WeekOfTheMonth.fitth.intLiteral:  [:], WeekOfTheMonth.sixth.intLiteral: [:]]
        
        self.climbingRecordList.forEach { record in
            //MARK: Chnage to Date Type
            let dateString = record.date
            let date = dateFormatter.date(from: dateString) ?? Date()
            
            //MARK: Get what week is the date included
            let weekOfMonth = calendar.component(.weekOfMonth, from: date)
            let dayOfWeek: DayNumber.RawValue = getDayOfWeek(dateString: dateString)
            
            //MARK: Matching week and date number with record data
            dividedMonthRecords[weekOfMonth]?.updateValue(record, forKey: dayOfWeek)
        }
                
        return dividedMonthRecords
    }
}
