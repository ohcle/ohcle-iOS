//
//  AppleLogin_Ohcle.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2022/11/27.
//

import SwiftUI

struct LoginResultModel: Decodable {
    let isUserSignedIn: Bool
    let userToken: String
    
    enum CodingKeys: String, CodingKey {
        case isUserSignedIn = "is_newbie"
        case userToken = "token"
    }
}

class NetworkManager {
    static let shared = NetworkManager()
    private init() { }
    
    func text() {
        guard let url = URL(string: "http://ohcle.net/v1/account/apple/signin") else {
            return
        }
        
        do {
            let request = try URLRequest(url: url, method: .post)
            URLSession.shared.dataTask(with: request) { data, response, error in
                // error
                
                // reponse code
                
                guard let data = data else {
                     return
                }
                
                do {
                    let decodedResult = try JSONDecoder().decode(LoginResultModel.self, from: data)
                    
                    print(decodedResult.userToken)
                    
                } catch(let loginError) {
                    print(loginError)
                }
            }.resume()
            
        } catch {
            
        }
    }
}

struct AppleLogin_Ohcle: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct AppleLogin_Ohcle_Previews: PreviewProvider {
    static var previews: some View {
        AppleLogin_Ohcle()
    }
}
