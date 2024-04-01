//
//   MontlyClimbingResponseDTO.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 3/28/24.
//

import Foundation

// MARK: - Climbing Data Transfer Object (기존에 CalenderModel이였던 것)
struct ClimbingMonthRecord {
    let list: [ClimbingRecord]
}

struct ClimbingRecord: Decodable {
    let id: Int
    let `where`: ClimbingLocation?
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
    
    struct ClimbingLocation: Decodable {
        let id: Int
        let name: String
        let address: String
        let latitude: Float
        let longitude: Float
    }
}

// MARK: - Mappings to Domain (실제 사용하는 데이터와 연결, 기존의 DividedWeekData 타입의 모델로 맵핑 필요)
extension ClimbingMonthRecord {
    func transformToDomin() -> MonthRecordEntity {
        return .init(monthRecord: self)
    }
}
