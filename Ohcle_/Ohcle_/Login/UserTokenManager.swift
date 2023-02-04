//
//  UserTokenManager.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2023/02/04.
//

import Foundation

final class UserTokenManager {
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
    func save(token: Data, account: String, service: String) {
        let query = [kSecValueData: token,
                         kSecClass: kSecClassGenericPassword,
                   kSecAttrService: service,
                   kSecAttrAccount: account] as CFDictionary
        
        let status = SecItemAdd(query, nil)
                
        switch status {
        case errSecDuplicateItem:
            updateToken(token, service: service, account: account)
        default:
            handleError(status: status)
        }
    }
    
    func updateToken(_ data: Data, service: String, account: String) {
        let query = [kSecAttrService: service,
                     kSecAttrAccount: account,
                           kSecClass: kSecClassGenericPassword] as CFDictionary
        
        let attibutesToUpdate = [kSecValueData: data] as CFDictionary
        
        SecItemUpdate(query, attibutesToUpdate)
    }
    
    func read(service: String, account: String) -> Data? {
        let query = [kSecAttrService: service,
                     kSecAttrAccount: account,
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
    
    func delete(service: String, account: String) {
        let query = [kSecAttrService: service, kSecAttrAccount: account, kSecClass: kSecClassGenericPassword] as CFDictionary
        SecItemDelete(query)
    }
}
