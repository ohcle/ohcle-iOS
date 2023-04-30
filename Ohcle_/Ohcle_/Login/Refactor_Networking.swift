//
//  Refactor_Networking.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2023/04/30.
//

import Foundation

enum GetRequestPurpose {
    case kakaoLogin
    case appleLogin
    case diaryList
    case diaryDetail
}

/*
 path, query item 을 네트워크 요청 종류 에 따라 구분
 -> url 만들기 -> 만들 url을 네트워크 요청하는 곳에 보내기
 
 네트워크 요청 하는아이는 url을 받아서 요청값을 보내주기만 함녀 됨. url만드는 것 까진 알 필요 없음
 
 url만드는 객체, network 요청하는 객체 이렇게 두개 만들면 도리 듯
 
url 만든는 객체가 알아야하는 정보
 url scheme
 base url
 path or query
 요청목적  -> 이에따라 path, query 정해짐
 
 return 하는 값 = url
 
 */


//class NetworManager {
//    static func request(purpose: NetworkingPurpose, userId: String?) {
//
//    }
//
//
//    func fetchData(urlString: String, method: HTTPMethod) async throws -> Data {
//        guard let url = URL(string: urlString) else {
//            return Data()
//        }
//
//        do {
//            let request = try URLRequest(url: url, method: method)
//            let (data, response) = try await URLSession.shared.data(for: request)
//            if let response = response as? HTTPURLResponse,
//                response.statusCode != 200 {
//                print(response.statusCode)
//            }
//            print(data)
//            return data
//        } catch {
//            print(error)
//            return Data()
//        }
//    }
//
//}

//class NetworManager {
//    typealias URLString = String
//
//    func request(purpose: NetworkingPurpose,
//                 userMemoId: String) async -> Data {
//
//        let url = generateURL(purpose: purpose, userMemoId: userMemoId)
//        var httpMethod: HTTPMethod = .get
//
//        switch purpose {
//        case .postClibmingMemo:
//            httpMethod = .post
//        case .deleteClimbingMemo(id: userMemoId):
//            httpMethod = .delete
//        default:
//            httpMethod = .get
//        }
//
//
//        do {
//            let request = try URLRequest(url: url, method: httpMethod)
//            let (data, response) = try await URLSession.shared.data(for: request)
//            if let response = response as? HTTPURLResponse,
//                response.statusCode != 200 {
//                print(response.statusCode)
//            }
//
//            print(data)
//            return data
//        } catch {
//            print(error)
//            return Data()
//        }
//    }
//
//    func request(purpose: NetworkingPurpose,
//                 month: String, year: String, view: OchleQueryItem) async -> Data {
//
//        let url = generateURL(purpose: purpose,
//                              month: month, year: year, view: view)
//
//        do {
//            let request = try URLRequest(url: url, method: httpMethod)
//            let (data, response) = try await URLSession.shared.data(for: request)
//            if let response = response as? HTTPURLResponse,
//                response.statusCode != 200 {
//                print(response.statusCode)
//            }
//
//            print(data)
//            return data
//        } catch {
//            print(error)
//            return Data()
//        }
//    }
//
//    private func generateURL(purpose: NetworkingPurpose, userMemoId: String) -> URL {
//        var urlComponent = URLComponents()
//
//        urlComponent.path = decidePath(purpose: purpose, userMemoId: userMemoId)
//
//        print(urlComponent.url)
//
//        guard let url = urlComponent.url else {
//            return defaultURL
//        }
//
//        return url
//    }
//
//    private func generateURL(purpose: NetworkingPurpose,
//                     month: String, year: String, view: OchleQueryItem) -> URL {
//        var urlComponent = URLComponents()
//
//        let unUsedUserId = "-1"
//        urlComponent.path = decidePath(purpose: purpose,
//                                       userMemoId: unUsedUserId)
//
//        let yearAndMonth = view.year + "-" + view.month
//        let queryItem = generateClimbingMemoQueryItem(viewType: view.viewType.rawValue,
//                                                      yearAndMonth: yearAndMonth)
//        urlComponent.queryItems = queryItem
//
//        print(urlComponent.url ?? "urlComponent 생성실패?!")
//
//        guard let url = urlComponent.url else {
//            return defaultURL
//        }
//
//        return url
//    }
//
//    private func generateQueryURL(purpose: NetworkingPurpose,
//                          month: String, year: String,
//                          view: OchleQueryItem) -> [URLQueryItem] {
//
//        switch purpose {
//        case .getClimbingMemo:
//            let yearAndMonth = view.year + "-" + view.month
//            return generateClimbingMemoQueryItem(viewType: view.viewType.rawValue,
//                                          yearAndMonth: yearAndMonth)
//        default:
//            return []
//        }
//    }
//
//    enum NetworkingPurpose {
//        case getKakaoLoginToken
//        case getAppleLoginToken
//        case getClimbingDetailMemo(id: String)
//        case getClimbingLevel
//        case postClibmingMemo
//        case deleteClimbingMemo(id: String)
//        case getClimbingMemo
//    }
//
//    private enum OhcleURLPath: String {
//        case kakaoLogin = "v1/signin/kakao"
//        case appleLogin = "v1/signin/apple"
//        case climbingMemo = "v1/climbing"
//        case climbingLevel = "v1/climbing/level"
//    }
//
//    struct OchleQueryItem {
//        let viewType: QueryViewType
//        let year: String
//        let month: String
//    }
//
//    enum QueryViewType: String {
//        case main
//        case list
//    }
//
//    private let baseURLString: String = "api-gw.todayclimbing.com"
//    private let scheme = "https"
//    private let defaultURL = URL(string: "https://www.google.com")!
//
//    private func decidePath(purpose: NetworkingPurpose, userMemoId: String) -> URLString {
//        switch purpose {
//        case .getKakaoLoginToken:
//            return OhcleURLPath.kakaoLogin.rawValue
//        case .getAppleLoginToken:
//            return OhcleURLPath.appleLogin.rawValue
//        case .getClimbingDetailMemo(id: let id):
//            return OhcleURLPath.climbingMemo.rawValue + "/\(id)/"
//        case .getClimbingLevel:
//            return OhcleURLPath.climbingLevel.rawValue
//        case .postClibmingMemo:
//            return OhcleURLPath.climbingMemo.rawValue + "/"
//        case .deleteClimbingMemo(id: let id):
//            return OhcleURLPath.climbingMemo.rawValue + "/\(id)/"
//        case .getClimbingMemo:
//            return OhcleURLPath.climbingMemo.rawValue
//        @unknown default:
//            return "error"
//        }
//    }
//
//    private func generateClimbingMemoQueryItem(viewType: String, yearAndMonth: String) -> [URLQueryItem] {
//        var queryItems: [URLQueryItem] = []
//        let yearComponent = URLQueryItem(name: "view", value: viewType)
//        let monthComponent = URLQueryItem(name: "month", value: yearAndMonth)
//
//        queryItems.append(yearComponent)
//        queryItems.append(monthComponent)
//
//        return queryItems
//    }
//}
