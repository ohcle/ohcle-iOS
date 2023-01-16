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

    var body: some View {
        ZStack {
            Color.init("DiaryBackgroundColor")
                .ignoresSafeArea(.all)
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
                        .onTapGesture {
                            Debouncer(delay: 0.5).run {
                                withAnimation {
                                    nextPageType.type = .level
                                }
                            }
                        }
                    }
                    .padding(.leading, commonSize.width * 0.2)
                }
                .frame(width: commonSize.width * 0.9,
                       height: commonSize.height)
            }
        }
    }
}

struct ClimbingLocation_Preview: PreviewProvider {
    @State static var path = NavigationPath()

    static var previews: some View {
        ClimbingLocation()
    }
}
