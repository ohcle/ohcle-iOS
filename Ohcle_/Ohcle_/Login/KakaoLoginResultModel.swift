//
//  LoginResultModel.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2022/12/04.
//

import Foundation

struct LoginResultModel: Decodable {
    let accessToken: String
    let refreshToken: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access"
        case refreshToken = "refresh"
    }
}
