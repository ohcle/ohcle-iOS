//
//  Test.swift
//  Ohcle_
//
//  Created by yeongbin ro on 2023/04/23.
//

import Foundation



class NetworkTest {
    var calenderData: CalenderData = CalenderData()
    
    func getList(url: String, completionHandler: @escaping (Bool, Any) -> Void) {
        let urlStr = "https://api-gw.todayclimbing.com/" +  "v1/climbing/"
        guard let url = URL(string: urlStr) else {
            print("Fail to InitURL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print("Error: error calling GET")
                print(error!)
                return
            }
            guard let data = data else {
                print("Error: Did not receive data")
                return
            }
            guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
                print("Error: HTTP request failed")
                return
            }
            guard let output = try? JSONDecoder().decode(Response.self, from: data) else {
                print("Error: JSON Data Parsing failed")
                return
            }
            
            completionHandler(true, output.result)
        }.resume()
    }
    
    
}
