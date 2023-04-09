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

//enum URLs: String {
//    case kakaoLogin = "http://ec2-3-37-182-202.ap-northeast-2.compute.amazonaws.com/v1/account/kakao/signin"
//    case appleLogin = "http://ec2-3-37-182-202.ap-northeast-2.compute.amazonaws.com/v1/account/apple/signin"
//}
