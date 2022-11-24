//
//  OhcleButton.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2022/11/12.
//

import SwiftUI

struct OhcleButton: View {
    @State var title: String
    let sizeRatio: (width: CGFloat, height: CGFloat)
    
    init(title: String, sizeRatio: (width: CGFloat, height: CGFloat) = (1,1)) {
        self.title = title
        self.sizeRatio = sizeRatio
    }
    
    var body: some View {
        GeometryReader { geometry in
            Button() {
                
            } label: {
                Text(title)
                    .fontWeight(.bold)
                    .font(.title3)
                    .padding()
                    .background(Color("editButton"))
                    .cornerRadius(8)
                    .foregroundColor(.white)
            }
            .padding(.leading,
                     geometry.size.width * (sizeRatio.width))
        }
    }
}

struct OhcleButton_Previews: PreviewProvider {
    static var previews: some View {
        OhcleButton(title: "수정하기", sizeRatio: (width: 2/7, height: 1))
    }
}
