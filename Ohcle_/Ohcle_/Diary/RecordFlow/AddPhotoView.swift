//
//  AddPhotoView.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2022/10/22.
//

import SwiftUI

struct AddPhotoView: View {
   @State private var titleSize = CGSize()
    @EnvironmentObject var nextPage: MyPageType
    private let titleImageHeighRatio = CGFloat(80/22)
    private let titleImageWidthRatio = CGFloat(268/80)

    var body: some View {
        VStack {
            (Text("오늘을 ")
             +
             Text("기록할 사진")
                .bold()
            +
             Text("이 있나요?")
            )
            .readSize(onChange: { size in
                self.titleSize = size
            })
            .font(.title)
            .padding()
            
            AddPhotoButton(imageName: "add-climbing-photo",
                           width: self.titleSize.width / titleImageWidthRatio,
                           height: self.titleSize.height * (titleImageHeighRatio),
                           selectedPhotos: [], data: nil)
            .onTapGesture {
                nextPage.pageType = .review
            }
        }
    }
}

struct AddPhotoView_Previews: PreviewProvider {
    static var previews: some View {
        AddPhotoView()
    }
}
