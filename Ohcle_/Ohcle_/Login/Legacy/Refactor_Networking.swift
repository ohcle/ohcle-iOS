//
//  Refactor_Networking.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2023/04/30.
//

import Foundation
import Alamofire

enum GetRequestPurpose {
    case kakaoLogin
    case appleLogin
    case diaryList
    case diaryDetail
}

class NetworkManager {
    typealias URLString = String

    func request(purpose: NetworkingPurpose,
                 httpMethod: HTTPMethod = .get,
                 userMemoId: Int) async -> Data {
        let userMemoIdString = String(userMemoId) ?? ""
        let url = generateURL(purpose: purpose, userMemoId: userMemoIdString)

        do {
            let request = try URLRequest(url: url, method: httpMethod)
            let (data, response) = try await URLSession.shared.data(for: request)
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                print(response.statusCode)
            }

            print(data)
            return data
        } catch {
            print(error)
            return Data()
        }
    }
    
    func requestMonthMemo(year: String, month: String) async -> Data {
        
        let url = generateURL(purpose: .getClimbingMemo,
                              month: month, year: year,
                              view: .init(viewType: .list, year: year, month: month))
        
        do {
            let request = try URLRequest(url: url, method: .get)
            let (data, response) = try await URLSession.shared.data(for: request)
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                print(response.statusCode)
            }

            print(data)
            return data
        } catch {
            print(error)
            return Data()
        }
    }
    
    // post, patch
    // body에 클라이밍 정보 넣어야함. encoder 필요, 파라미터는 사전으로 받기
    private func generateURL(purpose: NetworkingPurpose, userMemoId: String) -> URL {
        var urlComponent = URLComponents()

        urlComponent.path = decidePath(purpose: purpose, userMemoId: userMemoId)

        guard let url = urlComponent.url else {
            return defaultURL
        }

        return url
    }

    private func generateURL(purpose: NetworkingPurpose,
                     month: String, year: String,
                             view: OchleQueryItem) -> URL {
        var urlComponent = URLComponents()

        let unUsedUserId = "-1"
        urlComponent.path = decidePath(purpose: purpose,
                                       userMemoId: unUsedUserId)

        let yearAndMonth = view.year + "-" + view.month
        let queryItem = generateClimbingMemoQueryItem(viewType: view.viewType.rawValue,
                                                      yearAndMonth: yearAndMonth)
        urlComponent.queryItems = queryItem

        print(urlComponent.url ?? "urlComponent 생성실패?!")

        guard let url = urlComponent.url else {
            return defaultURL
        }

        return url
    }

    private func generateQueryURL(purpose: NetworkingPurpose,
                          month: String, year: String,
                          view: OchleQueryItem) -> [URLQueryItem] {

        switch purpose {
        case .getClimbingMemo:
            let yearAndMonth = view.year + "-" + view.month
            return generateClimbingMemoQueryItem(viewType: view.viewType.rawValue,
                                          yearAndMonth: yearAndMonth)
        default:
            return []
        }
    }

    enum NetworkingPurpose {
        case getKakaoLoginToken
        case getAppleLoginToken
        case getClimbingDetailMemo(id: String)
        case getClimbingLevel
        case postClibmingMemo
        case deleteClimbingMemo(id: String)
        case getClimbingMemo
    }

    private enum OhcleURLPath: String {
        case kakaoLogin = "v1/signin/kakao"
        case appleLogin = "v1/signin/apple"
        case climbingMemo = "v1/climbing"
        case climbingLevel = "v1/climbing/level"
    }

    struct OchleQueryItem {
        let viewType: QueryViewType
        let year: String
        let month: String
    }

    enum QueryViewType: String {
        case main
        case list
    }

    private let baseURLString: String = "api-gw.todayclimbing.com"
    private let scheme = "https"
    private let defaultURL = URL(string: "https://www.google.com")!

    private func decidePath(purpose: NetworkingPurpose, userMemoId: String) -> URLString {
        switch purpose {
        case .getKakaoLoginToken:
            return OhcleURLPath.kakaoLogin.rawValue
        case .getAppleLoginToken:
            return OhcleURLPath.appleLogin.rawValue
        case .getClimbingDetailMemo(id: let id):
            return OhcleURLPath.climbingMemo.rawValue + "/\(id)/"
        case .getClimbingLevel:
            return OhcleURLPath.climbingLevel.rawValue
        case .postClibmingMemo:
            return OhcleURLPath.climbingMemo.rawValue + "/"
        case .deleteClimbingMemo(id: let id):
            return OhcleURLPath.climbingMemo.rawValue + "/\(id)/"
        case .getClimbingMemo:
            return OhcleURLPath.climbingMemo.rawValue
        @unknown default:
            return "error"
        }
    }

    private func generateClimbingMemoQueryItem(viewType: String, yearAndMonth: String) -> [URLQueryItem] {
        var queryItems: [URLQueryItem] = []
        let yearComponent = URLQueryItem(name: "view", value: viewType)
        let monthComponent = URLQueryItem(name: "month", value: yearAndMonth)

        queryItems.append(yearComponent)
        queryItems.append(monthComponent)

        return queryItems
    }
}
