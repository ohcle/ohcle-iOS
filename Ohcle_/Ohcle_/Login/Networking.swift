//
//  Networking.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2023/02/15.
//

import Foundation
import Alamofire

func getAccessTokenURL(_ url: OhcleURLs) -> URL {
    guard let url = URL(string: url.rawValue) else {
        return URL(string: "https://www.bing.com")!
    }
    
    return url
}

enum OhcleURLs: String {
    case baseURL = "https://api-gw.todayclimbing.com/"
    case kakaoLogin = "https://api-gw.todayclimbing.com/v1/user/login/kakao"
    case appleLogin = "https://api-gw.todayclimbing.com/v1/user/login/apple"
    
    static func generateMonthRecordURLString(year: String, month: String,
                                       baseURL: OhcleURLs = .baseURL) -> String {
        return baseURL.rawValue + "v1/climbing/?view=list&month=\(year)-\(month)"
    }
}

func fetchData(urlString: String, method: HTTPMethod) async throws -> Data {
    guard let url = URL(string: urlString) else {
        return Data()
    }
    
    do {
        let request = try URLRequest(url: url, method: method)
        let (data, response) = try await URLSession.shared.data(for: request)
        if let response = response as? HTTPURLResponse,
            response.statusCode != 200 {
            print(response.statusCode)
        }
        return data
    } catch {
        print(error)
        return Data()
    }
}
