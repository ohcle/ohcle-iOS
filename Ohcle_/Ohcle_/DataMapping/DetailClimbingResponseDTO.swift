//
//  DailyClimbingResponseDTO.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 3/28/24.
//

import Foundation

// MARK: - Detail Climbing Record Data Transfer Object
struct DetailClimbingResponseDTO: Decodable {
    let id: Int
    let `where`: Location?
    let when: String
    let level: Int
    let score: Float
    let memo: String
    let picture: [String?]?
    let video: [String]?
    let tags: [String]?
    let created_at: String
    let modified_at: String
    let deleted_at: String?
    
    struct Location: Decodable {
        let id: Int?
        let name: String
        let address: String
        let latitude: Float
        let longitude: Float
    }
}

// MARK: - Mappings to Domain (실제페이지와 연결)
extension ClimbingMonthRecord {
    
}
