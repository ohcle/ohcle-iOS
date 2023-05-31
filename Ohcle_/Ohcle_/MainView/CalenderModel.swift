//
//  CalenderModel.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2023/04/16.
//

import Foundation

struct CalenderModel: Decodable, Identifiable,Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func ==(lhs: CalenderModel,
                   rhs: CalenderModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    let id: Int
    let `where`: ClimbingLocation?
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
    
    struct ClimbingLocation: Decodable {
        let id: Int
        let name: String
        let address: String
        let latitude: Float
        let longitude: Float
    }
}


//let errorString = "{\"id\":66,\"where\":null,\"when\":\"2023-05-05\",\"level\":7,\"score\":3.0,\"memo\":\"\",\"picture\":[null],\"video\":null,\"tags\":null,\"created_at\":\"2023-05-28T12:03:18.232471Z\",\"modified_at\":\"2023-05-31T10:03:52.868377Z\",\"deleted_at\":null}")

struct DetailClimbingModel: Decodable {
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

struct ClimbingImageModel: Decodable {
    let image: String
}

struct ConvertedClimbingImageModel: Decodable {
    let filename: String
}

