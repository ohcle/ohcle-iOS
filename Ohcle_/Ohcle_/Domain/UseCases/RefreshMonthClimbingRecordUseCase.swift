//
//  DefaultRefreshClimbingRecordUseCase.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 3/29/24.
//

import Foundation

protocol RefreshClimbingRecordUseCase {
    func fetch(requestValue: ClimbingRecordDate) async -> Result<ClimbingRecord, Error>
}

final class RefreshMonthClimbingRecordUseCase: RefreshClimbingRecordUseCase {
    private let reppository: RecordsRepository

    init(repository: RecordsRepository) {
        self.reppository = repository
    }
    
    func fetch(requestValue: ClimbingRecordDate) async -> Result<ClimbingRecord, Error> {
        
        //MARK: Devlivering info for Networking
       let result = await reppository.fetch(requestValue: requestValue)
        
        
        return result
    }
}


