//
//   MontlyClimbingResponseDTO.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 3/28/24.
//

import Foundation

// MARK: - Climbing Data Transfer Object
struct MonthlyClimbingReponseDTO: Decodable, Identifiable, Hashable {
    let id: Int
    let `where`: ClimbingLocationDTO?
    let when: String
    let level: Int
    let score: Float
    let picture: [String?]?
    let thumbnail: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case `where`
        case when
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
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: MonthlyClimbingReponseDTO,
                   rhs: MonthlyClimbingReponseDTO) -> Bool {
        return lhs.id == rhs.id
    }
}

// MARK: - Mappings to Domain (실제페이지와 연결)

