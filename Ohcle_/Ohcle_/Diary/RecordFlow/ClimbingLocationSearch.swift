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
    @Binding var selectedLocation: ClimbingLocation
    @Binding var selectedname: String
    @State var getResFromServer: Bool = false
    @State private var keyboardHeight: CGFloat = 0

    @Environment(\.presentationMode) var presetntationMode
    
    var body: some View {
        
        VStack (spacing: 25){
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray, lineWidth: 2)
                    .padding(.horizontal, 20)
                
                TextField("장소를 입력해 주세요", text: $searchText, onCommit: {
                    print("Submit")
                    climbingLocations.removeAll()
                    RecNetworkManager.shared.fetchClimbingPlace(with: searchText) { result in
                        switch result {
                        case .success(let climbLocations):
                            self.climbingLocations = climbLocations
                        case .failure(let error):
                            print(error)
                        }
                        getResFromServer = true
                    }
                })
                .frame(height: 40)
                .padding(.leading, 30)
            }
            .frame(height: 20)
            .padding(.top, 10)
            
            if getResFromServer {
                if climbingLocations.count != 0 {
                    List(climbingLocations){ climbingLocation in
                        HStack {
                            Text(climbingLocation.name)
                                .frame(width:150, alignment: .leading)
                            Text(climbingLocation.address)
                                .frame(alignment: .leading)
                        }
                        .frame(height:50, alignment: .leading)
                        .listRowInsets(EdgeInsets())
                        .onTapGesture {
                            print("tapped \(climbingLocation.name),\(climbingLocation.latitude),\(climbingLocation.longitude)")
                            selectedname = climbingLocation.name
                            selectedLocation = climbingLocation
                            print(selectedname, selectedLocation)
                            presetntationMode.wrappedValue.dismiss()
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                    }
                    .listStyle(.plain)
                } else {
                    Text("검색 결과가 없습니다. 지역명/클라이밍 장소명으로 검색해 주세요☺️")
                        .padding()
                }
            }
            
            Spacer()
            HStack{
                
            }
            .frame(height: keyboardHeight)
            
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            // Left Button
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    presetntationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "chevron.backward")
                        .foregroundColor(.gray)
                }
                
            }
        }
//        .offset(y: self.keyboardHeight)
        .ignoresSafeArea(.keyboard)
        .onAppear {
                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notification in
                    guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
                        return
                    }
                    
                    self.keyboardHeight = keyboardFrame.height / 2 + 30
                }
                
                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { notification in
                    
                    self.keyboardHeight = 0
                }

        }
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)

        }
        
        
    }
}


//struct ClimbingLocationSearch_Previews: PreviewProvider {
//    static var previews: some View {
//        ClimbingLocationSearch()
//    }
//}
