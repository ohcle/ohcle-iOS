//
//  RecordsRepository.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 3/30/24.
//

import Foundation

protocol RecordsRepository {
    //MARK: Fetching Month Climbing Records
    func fetch(requestValue: ClimbingRecordDate) async -> Result<MonthRecordEntity, Error>
}

final class MonthRecordRepository: RecordsRepository {

    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    //MARK: Networking
    func fetch(requestValue: ClimbingRecordDate) async -> Result<MonthRecordEntity, Error> {
        do {
            let dto = await self.networkService.request(value: requestValue)
            let climbingRecords = try dto.get()
            let entity = ClimbingMonthRecord(list: climbingRecords).transformToDomin()
            
            return .success(entity)
        } catch {
            return .failure(error)
        }
    }
}
