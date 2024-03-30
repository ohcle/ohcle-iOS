//
//  RecordsRepository.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 3/30/24.
//

import Foundation

protocol RecordsRepository {
    //MARK: Fetching Month Climbing Records
    func fetch(requestValue: ClimbingRecordDate) async -> Result<ClimbingRecord, Error>
}

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

final class MonthRecordRepository: RecordsRepository {
    
    //MARK: Networking
    func fetch(requestValue: ClimbingRecordDate) async -> Result<ClimbingRecord, Error> {
        
        //FIX: Implement Data Source
        do {
            guard let url = URL(string: OhcleURLs.generateMonthRecordURLString(year: requestValue.year, month: requestValue.month)) else {
                throw NetworkingError.invalidURL
            }
            
            var request = try URLRequest(url: url, method: .get)
            request.headers.add(name: "Authorization",
                                value: "Bearer " + LoginManager.shared.ohcleAccessToken)
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkingError.invalidResponse
            }
            
            let responseCode = httpResponse.statusCode

            if responseCode != 200 {
                throw NetworkingError.getStatusCode(responseCode)
            }
            
            let records = try JSONDecoder().decode(ClimbingRecord.self, from: data)
            
            return .success(records)
        } catch {
            return .failure(NetworkingError.undefined)
        }
    }
}
