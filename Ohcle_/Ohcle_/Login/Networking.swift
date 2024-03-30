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
    case baseURL = "http://13.125.173.42/"
    case kakaoLogin = "http://13.125.173.42/v1/user/login/kakao"
    case appleLogin = "http://13.125.173.42/user/login/apple"
    
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
        var request = try URLRequest(url: url, method: method)
        request.headers.add(name: "Authorization",
                            value: "Bearer " + LoginManager.shared.ohcleAccessToken)
        
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
