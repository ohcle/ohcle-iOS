//
//  CalenderModel.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2023/04/16.
//

import Foundation

struct CalenderViewModel: Decodable {
    let id: Int
    let `where`: ClimbingLocation
    let when: String
    let level: Int
    let score: Float
    
    enum CodingKeys: String, CodingKey {
          case id
          case `where` // Use backticks to escape the reserved keyword "where"
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
