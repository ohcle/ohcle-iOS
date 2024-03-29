//
//  ClimbingRecord.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 3/28/24.
//

import Foundation

//MARK: - Domain Layer - Entity (사용자에게 보여줄 데이터)
struct MonthlyClimbingRecord {
    let date: String
    let level: String
    let score: Score.RawValue
    let photo: Data
    let photoName: String
    let memo: String
    let climbingLocation: ClimbingLocationInfo
    
    enum Score: Int {
        case oneStar
        case twoStar
        case threeStar
        case fourStar
        case fiveStar
    }
}

struct ClimbingLocationInfo: Identifiable {
    let id: Int
    let name: String
    let address: String
    let latitude: Float
    let longitude: Float
}
