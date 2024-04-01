//
//  NetworkService.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 3/31/24.
//

import Foundation

final class NetworkService {
    //FIXME : Implement Network layer (Endpoint, URL, Request ..)
    func request(value: ClimbingRecordDate) async -> Result<[ClimbingRecord],Error> {
        do {
            guard let url = URL(string: OhcleURLs.generateMonthRecordURLString(year: value.year, month: value.month)) else {
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
            
            let records = try JSONDecoder().decode([ClimbingRecord].self, from: data)

            return .success(records)
        } catch {
            return .failure(NetworkingError.undefined)
        }
    }
}
