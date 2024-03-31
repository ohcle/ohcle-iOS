//
//  NetworkError.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 3/31/24.
//

import Foundation

enum NetworkingError: Error {
    case invalidURL
    case invalidResponse
    case client
    case server
    case undefined
    
    static func getStatusCode(_ responseCode: Int) -> Self {
        switch responseCode {
        case (400...499) :
            return .client
        case (500...) :
            return .server
        default:
            return .invalidResponse
        }
    }
}
