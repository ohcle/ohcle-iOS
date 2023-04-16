//
//  Networking.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2023/02/15.
//

import Foundation

func getAccessTokenURL(_ url: URLs) -> URL {
    guard let url = URL(string: url.rawValue) else {
        return URL(string: "https://www.bing.com")!
    }
    
    return url
}

enum URLs: String {
    case kakaoLogin = "https://api-gw.todayclimbing.com/v1/signin/kakao"
    case appleLogin = "https://api-gw.todayclimbing.com/v1/signin/apple"
}
