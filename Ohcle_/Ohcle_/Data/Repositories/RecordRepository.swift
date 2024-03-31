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

final class MonthRecordRepository: RecordsRepository {
    
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    //MARK: Networking
    func fetch(requestValue: ClimbingRecordDate) async -> Result<ClimbingRecord, Error> {
        
        await self.networkService.request(value: requestValue)
    }
}
