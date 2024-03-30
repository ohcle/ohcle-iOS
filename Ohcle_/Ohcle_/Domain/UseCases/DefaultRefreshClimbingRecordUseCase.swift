//
//  DefaultRefreshClimbingRecordUseCase.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 3/29/24.
//

import Foundation

protocol RefreshClimbingRecordUseCase {
    associatedtype requestValue
    func fetch(requestValue: requestValue)
}

struct RefreshRecordsUseCaseRequestValue {
    let year: String
    let month: String
}

final class DefaultRefreshClimbingRecordUseCase: RefreshClimbingRecordUseCase {
    
    //MARK: Climbing Records Repository
    let reppository: RecordsRepository? = nil

    func fetch(requestValue: RefreshRecordsUseCaseRequestValue) {
        //MARK: Devlivering info for Networking

    }
}


