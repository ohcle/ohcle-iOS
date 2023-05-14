//
//  CalenderModel.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2023/04/16.
//

import Foundation

struct CalenderViewModel: Decodable, Identifiable,Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func ==(lhs: CalenderViewModel,
                   rhs: CalenderViewModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    let id: Int
    let `where`: ClimbingLocation?
    let when: String
    let level: Int
    let score: Float
    let picture: [String]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case `where`
        case when
        case level
        case score
        case picture
    }
    
    struct ClimbingLocation: Decodable {
        let id: Int
        let name: String
        let address: String
        let latitude: Float
        let longitude: Float
    }
}

struct DetailClimbingModel: Decodable {
    let id: Int
    let `where`: Location
    let when: String
    let level: Int
    let score: Float
    let memo: String
    let picture: [String]?
    let video: [String]?
    let tags: [String]?
    let created_at: String
    let modified_at: String
    let deleted_at: String?
    
    struct Location: Decodable {
        let id: Int
        let name: String
        let address: String
        let latitude: Float
        let longitude: Float
    }
}
