//
//  LoginResultModel.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2022/12/04.
//

import Foundation

struct LoginResultModel: Decodable {
    let userID: Int
    let isUserSignedIn: Bool
    let token: String
    
    enum CodingKeys: String, CodingKey {
        case userID = "id"
        case isUserSignedIn = "is_newbie"
        case token = "token"
    }
}
