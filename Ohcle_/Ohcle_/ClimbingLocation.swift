//
//  ClimbingLocagion.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2022/10/15.
//

import SwiftUI
import CoreLocation

struct IdentifiableSpace: Identifiable {
    let id: UUID
    let location: CLLocationCoordinate2D
    
    init(id: UUID, lat: Double, long: Double) {
        self.id = id
        let location = CLLocationCoordinate2D(latitude: lat, longitude: long)
        self.location = location
    }
}

struct ClimbingLocation: View {
    @State private var searchText = ""
    @State var commonSize = CGSize()
    @State private var isLocateChanged: Bool = false
    @EnvironmentObject var nextPageType: MyPageType
    private var nextButton: NextPageButton =  NextPageButton(title: "다음 페이지로",
                                                             width: UIScreen.screenWidth/1.2,
                                                             height: UIScreen.screenHeight/15)
    var body: some View {
        VStack {
            (Text("어디서")
                .bold()
             +
             Text(" 클라이밍 하셨어요?"))
            .font(.title)
            .readSize { textSize in
                commonSize = textSize
            }
            .padding(.bottom, commonSize.height * 0.7)
            
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray, lineWidth: 2)
                    .background(.white)
                    .frame(width: commonSize.width,
                           height: commonSize.height * 1.5)
                HStack {
                    Image("locationSearchBarIcon")
                    TextField("장소를 입력해 주세요",
                              text: $searchText)
                }
                .padding(.leading, commonSize.width * 0.2)
            }
            .frame(width: commonSize.width * 0.9,
                   height: commonSize.height)
        }
        .overlay(
            self.nextButton
                .offset(CGSize(width: 0, height: UIScreen.screenHeight/4))
        )
    }
}

struct ClimbingLocation_Preview: PreviewProvider {
    @State static var path = NavigationPath()
    
    static var previews: some View {
        ClimbingLocation()
    }
}


//naver api 찾기 
