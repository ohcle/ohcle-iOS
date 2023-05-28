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
                        RecNetworkManager.shared.fetchClimbingPlace(with: searchText) { result in
                            switch result {
                            case .success(let climbLocations):
                                self.climbingLocations = climbLocations
                            case .failure(let error):
                                print(error)
                            }
                        }
                    }
                    .padding(.leading, 20)
            }
            .frame(height: 20)
            .padding(.top, 10)
            
            
            List(climbingLocations){ climbingLocation in
                HStack {
                    Text(climbingLocation.name)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: 150)
                    Text(climbingLocation.address)
                }
                .frame(maxHeight:50, alignment: .leading)
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


//struct ClimbingLocationSearch_Previews: PreviewProvider {
//    static var previews: some View {
//        ClimbingLocationSearch()
//    }
//}
