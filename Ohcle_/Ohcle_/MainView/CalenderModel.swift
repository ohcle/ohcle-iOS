//
//  CalenderModel.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2023/04/16.
//

import Foundation

struct CalenderViewModel: Decodable, Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func ==(lhs: CalenderViewModel, rhs: CalenderViewModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    let id: Int
    let `where`: ClimbingLocation
    let when: String
    let level: Int
    let score: Float
    
    enum CodingKeys: String, CodingKey {
        case id
        case `where`
        case when
        case level
        case score
    }
    
    struct ClimbingLocation: Decodable {
        let name: String
        let address: String
        let latitude: Float
        let longitude: Float
    }
}
