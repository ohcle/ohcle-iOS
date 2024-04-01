//
//  DefaultRefreshClimbingRecordUseCase.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 3/29/24.
//

import Foundation

protocol RefreshClimbingRecordUseCase {
    func fetch(requestValue: ClimbingRecordDate) async -> Result<MonthRecordEntity, Error>
}

final class RefreshMonthClimbingRecordUseCase: RefreshClimbingRecordUseCase {
    private let repository: RecordsRepository
    
    init(repository: RecordsRepository) {
        self.repository = repository
    }
    
    func fetch(requestValue: ClimbingRecordDate) async -> Result<MonthRecordEntity, Error> {
        
        //MARK: Devlivering info for Networking
        let result = await repository.fetch(requestValue: requestValue)
        return result.mapError { $0 as Error }
    }
}


