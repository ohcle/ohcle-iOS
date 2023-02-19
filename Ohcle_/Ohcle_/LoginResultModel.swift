//
//  LoginResultModel.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2022/12/04.
//

import Foundation

struct LoginResultModel: Decodable {
    let isUserSignedIn: Bool
    let userToken: String
    
    enum CodingKeys: String, CodingKey {
        case isUserSignedIn = "is_newbie"
        case userToken = "token"
    }
}

struct TokenModel: Decodable {
    let is_newbie: Bool
    let token: String
}
