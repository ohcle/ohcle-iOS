//
//  RecNetowrkManager.swift
//  Ohcle_
//
//  Created by yeongbin ro on 2023/05/28.
//

import Foundation
import Alamofire

class RecNetworkManager {
    static let shared = RecNetworkManager()

    private init() {}


    private func createURLRequest(urlString: String, method: HTTPMethod) throws -> URLRequest {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        return request
    }

    private func performRequest(urlString: String, method: HTTPMethod, parameters: [String: Any]? = nil, completion: @escaping (Result<Data, Error>) -> Void) {
        do {
            var request = try createURLRequest(urlString: urlString, method: method)
            
            if let parameters = parameters, method == .post {
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
            }
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let response = response as? HTTPURLResponse else {
                    completion(.failure(URLError(.badServerResponse)))
                    return
                }

                if Int(response.statusCode / 100) == 2 {
                    if let data = data {
                        completion(.success(data))
                    } else {
                        completion(.failure(URLError(.zeroByteResource)))
                    }
                } else {
                    print(String(data: data ?? Data(), encoding: .utf8))
                    completion(.failure(URLError(.init(rawValue: response.statusCode))))
                    var errorMsg = "error Code:\(String(response.statusCode))\n"
                    errorMsg += (error?.localizedDescription ?? "")
                    AlertManager.shared.showAlert(message: errorMsg)
                }
            }.resume()
        } catch {
            completion(.failure(error))
        }
    }

    // MARK: - Public Methods

    func deleteClimbing(id: Int) {
        let urlStr = "https://api-gw.todayclimbing.com/v1/climbing/\(id)"
        performRequest(urlString: urlStr, method: .delete) { result in
            // Handle the result here
        }
    }

    func fetchClimbingPlaceWithLoc(latitude: Double, longitude: Double, completion: @escaping (Result<[ClimbingLocation], Error>) -> Void) {
        let baseURLString = "https://api-gw.todayclimbing.com/v1/climbing/place/nearby"
        let urlString = "\(baseURLString)?latitude=\(latitude)&longitude=\(longitude)"
        performRequest(urlString: urlString, method: .get) { result in
            switch result {
            case .success(let data):
                do {
                    let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
                    let climbingLocations = jsonArray?.compactMap { ele -> ClimbingLocation? in
                        let id = ele["id"] as? Int ?? 0
                        let name = ele["name"] as? String ?? ""
                        let addr = ele["address"] as? String ?? ""
                        let lat = ele["latitude"] as? Double ?? 0.0
                        let long = ele["longitude"] as? Double ?? 0.0
                        return ClimbingLocation(id: id, name: name, address: addr, latitude: Float(lat), longitude: Float(long))
                    }
                    completion(.success(climbingLocations ?? []))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func fetchClimbingPlace(with keyword: String, completion: @escaping (Result<[ClimbingLocation], Error>) -> Void) {
        let baseURLString = "https://api-gw.todayclimbing.com/v1/climbing/place/"
        let encodedKeyword = keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = baseURLString + "?search_words=" + encodedKeyword
        performRequest(urlString: urlString, method: .get) { result in
            switch result {
            case .success(let data):
                do {
                    let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
                    let climbingLocations = jsonArray?.compactMap { ele -> ClimbingLocation? in
                        let id = ele["id"] as? Int ?? 0
                        let name = ele["name"] as? String ?? ""
                        let addr = ele["address"] as? String ?? ""
                        let lat = ele["latitude"] as? Double ?? 0.0
                        let long = ele["longitude"] as? Double ?? 0.0
                        return ClimbingLocation(id: id, name: name, address: addr, latitude: Float(lat), longitude: Float(long))
                    }
                    completion(.success(climbingLocations ?? []))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    

    func postImage(_ imgData: Data, completion: ((Result<Data, Error>) -> Void)? ) {
        let urlStr = "https://api-gw.todayclimbing.com/v1/media/image/"
        
        performRequest(urlString: urlStr, method: .post, parameters: ["image": imgData.base64EncodedString()]) { result in
            // Handle the result here
            if let completion = completion {
                completion(result)
            }
        }
    }
    
    func saveDiaryToServer(completion: @escaping (Bool) -> Void) {
        let urlStr = "https://api-gw.todayclimbing.com/v1/climbing/"
        
        let date = CalendarDataManger.shared.record.date
        let score = CalendarDataManger.shared.record.score
        let level = CalendarDataManger.shared.record.level
        let photoNm = CalendarDataManger.shared.record.photoName
        let memo = CalendarDataManger.shared.record.memo

        let parameters: [String: Any] = [
            "where": [
                "id": 1
            ],
            "when": date,
            "level": getLevel(level),
            "score": score,
            "memo": memo,
            "picture": (photoNm.count==0 ? nil : [photoNm])
        ]
        
        performRequest(urlString: urlStr, method: .post, parameters: parameters) { result in
            switch result {
            case .success(_):
                completion(true)
            case .failure(_):
                completion(false)
            }
            
        }
    }
    
    private func getLevel(_ levelStr: String) -> Int {
        let levelDict = [
            "red": 1,
            "orange": 2,
            "yellow": 3,
            "green": 4,
            "holder-darkblue": 5,
            "blue": 6,
            "purple": 7,
            "black": 8,
            "holder-lightgray": 9,
            "holder-darkgray": 10
        ]
        return levelDict[levelStr] ?? 0
    }
}
