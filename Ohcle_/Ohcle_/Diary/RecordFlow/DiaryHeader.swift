//
//  DiaryHeader.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2022/11/12.
//

import SwiftUI


struct DiaryHeader: View {
    private let currentDate: String = {
        let currentDate = Date()
        let formatter = DateFormatter()
        
        formatter.timeStyle = .none
        formatter.dateStyle = .medium
        formatter.locale = Locale(identifier: "ko")
        formatter.setLocalizedDateFormatFromTemplate("yyyy MMMM")
        return formatter.string(from: currentDate)
    }()
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack {
                    Text(currentDate)
                        .font(.title)
                        .padding(.bottom, 10)
                    Image(systemName: "arrow")
                }
                
                Rectangle()
                    .size(width: geometry.size.width * (8/10), height: 1)
                    .padding(.leading, geometry.size.width * (1/10))
                    .padding(.trailing, geometry.size.width * (1/10))
            }
        }
    }
}


struct DiaryHeader_Previews: PreviewProvider {
    static var previews: some View {
        DiaryHeader()
    }
}
