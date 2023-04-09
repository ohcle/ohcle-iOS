//
//  UserTokenManager.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2023/02/04.
//

import Foundation

final class UserTokenManager {
    enum Account: String {
        case kakao
        case apple
    }
    
    enum Service: String {
        case login
    }
    
    static let shared = UserTokenManager()
    private init() { }
    
    private func handleError(status: OSStatus) {
        if status != errSecSuccess {
            print("Error: \(status)")
        }
    }
    
    ///data: 키체인에 저장하려는 토큰, account: 어떤 목적의 토큰인지, service: 어느서비스에서 사용되는 토큰인지
    ///- 예시 코드
    ///let tokenWhichYouWantToSave = "ohcleTokenOhcleToken"
    ///let tokenData = Data(tokenWhichYouWantToSave.utf8)
    ///save(token: tokenData, account: "access-token", service: "Ochle")
    func save(token: Data, account: Account, service: Service) {
        let query = [kSecValueData: token,
                         kSecClass: kSecClassGenericPassword,
                   kSecAttrService: service.rawValue,
                   kSecAttrAccount: account.rawValue] as CFDictionary
        
        let status = SecItemAdd(query, nil)
                
        switch status {
        case errSecDuplicateItem:
            updateToken(token, account: account, service: service)
        default:
            handleError(status: status)
        }
    }
    
    func updateToken(_ data: Data, account: Account, service: Service) {
        let query = [kSecAttrService: service.rawValue,
                     kSecAttrAccount: account.rawValue,
                           kSecClass: kSecClassGenericPassword] as CFDictionary
        
        let attibutesToUpdate = [kSecValueData: data] as CFDictionary
        
        SecItemUpdate(query, attibutesToUpdate)
    }
    
    func read(account: Account, service: Service) -> Data? {
        let query = [kSecAttrService: service.rawValue,
                     kSecAttrAccount: account.rawValue,
                           kSecClass: kSecClassGenericPassword,
                      kSecReturnData: true] as CFDictionary
        
        var result: AnyObject?
        SecItemCopyMatching(query, &result)
        
        if let result = result as? OSStatus {
            handleError(status: result)
        }
        
        let data = result as? Data
        return data
    }
    
    func delete(account: Account, service: Service) {
        let query = [kSecAttrService: service.rawValue,
                     kSecAttrAccount: account.rawValue,
                           kSecClass: kSecClassGenericPassword] as CFDictionary
        SecItemDelete(query)
    }
}
