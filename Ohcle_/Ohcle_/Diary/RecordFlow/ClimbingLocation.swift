//
//  ClimbingLocagion.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2022/10/15.
//

import SwiftUI

struct ClimbingLocation: View {
    @State private var searchText = ""
    @State var commonSize = CGSize()
    
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
            .padding(.bottom, commonSize.height * 0.8)
                        
            ZStack {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    //.backgroundStyle(.bar)
                    .fill(.bar)
                    .frame(width: commonSize.width,
                           height: commonSize.height * 1.2)
                HStack {
                    Image("locationSearchBarIcon")
                    TextField("장소를 입력해 주세요",  text: $searchText)
                    
                }
                .padding(.leading, 13)
                
            }
            .frame(width: commonSize.width * 0.9,
                   height: commonSize.height)
        }
        
    }
}



struct ClimbingLocation_Preview: PreviewProvider {
    static var previews: some View {
        ClimbingLocation()
    }
}
