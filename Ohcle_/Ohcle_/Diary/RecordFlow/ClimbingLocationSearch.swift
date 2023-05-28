//
//  ClimbingLocationSearch.swift
//  Ohcle_
//
//  Created by yeongbin ro on 2023/05/21.
//

import SwiftUI

struct ClimbingLocationSearch: View {
    @State private var searchText = ""
    @State private var climbingLocations: [ClimbingLocation] = []
    @Binding var selectedLocation:ClimbingLocation
    @Binding var selectedname: String
    @Environment(\.presentationMode) var presetntationMode
    
    var body: some View {
        
        VStack (spacing: 25){
            
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray, lineWidth: 2)
                    .padding(.horizontal,10)
                
                TextField("장소를 입력해 주세요",text: $searchText)
                    .frame(height: 40)
                    .onSubmit {
                        print("Submit")
                        climbingLocations.removeAll()
                        fetchClimbinPlace(searchText)
                    }
                    .padding(.leading, 20)
            }
            .frame(height: 20)
            .padding(.top, 10)
            
            
            List(climbingLocations){ climbingLocation in
                HStack{
                    Text(climbingLocation.name)
                        .frame(maxWidth: 150)
                    Text(climbingLocation.address)
                }
                .frame(maxHeight:50)
                .listRowInsets(EdgeInsets())
                .onTapGesture {
                    print("tapped \(climbingLocation.name),\(climbingLocation.latitude),\(climbingLocation.longitude)")
                    selectedname = climbingLocation.name
                    selectedLocation = climbingLocation
                    
                    presetntationMode.wrappedValue.dismiss()
                }
            }
            .edgesIgnoringSafeArea(.all)
            .listStyle(.plain)
        }

        
        
    }
}

// MARK: Network function
extension ClimbingLocationSearch {
    
    
    private func fetchClimbinPlace(_ keyword: String) {
        guard var urlComponents = URLComponents(string: "https://api-gw.todayclimbing.com/" + "v1/climbing/place/") else { return }
        let queryItems = [
            URLQueryItem(name: "keyword", value: keyword)
        ]
        urlComponents.queryItems = queryItems
        guard let url = urlComponents.url else { return }
        
        
        do {
            let request = try URLRequest(url: url, method: .get)
            URLSession.shared.dataTask(with: request) { data, response, error in
                
                if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                    print(response.statusCode)
                }
                
                if let data = data {
                    
                    print(data)
                    print(String(data: data, encoding: .utf8))
                    do {
                        if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String:Any]] {

                            for ele in jsonArray {
                               print(ele)
                                let id   = ele["id"]        as? Int     ?? 0
                                let name = ele["name"]      as? String  ?? ""
                                let addr = ele["address"]   as? String  ?? ""
                                let lat  = ele["latitude"]  as? Double   ?? 0.0
                                let long = ele["longitude"] as? Double   ?? 0.0
                                
                                climbingLocations.append(ClimbingLocation(id: id, name: name, address: addr, latitude: Float(lat), longitude: Float(long)))
                            }
                        }
                        

                    }
                    catch {
                        print("JsonSerialization error \(error)")
                    }

                    
                }
                
            }
            .resume()
        } catch {
            print(error)
        }
        
        
    }
}

//struct ClimbingLocationSearch_Previews: PreviewProvider {
//    static var previews: some View {
//        ClimbingLocationSearch()
//    }
//}
