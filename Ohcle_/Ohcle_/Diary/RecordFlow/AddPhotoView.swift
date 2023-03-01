//
//  AddPhotoView.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2022/10/22.
//

import SwiftUI
import PhotosUI

struct AddPhotoView: View {
    @EnvironmentObject var nextPage: MyPageType
    @ObservedObject var picker = ClimbingImagePicker()

    private let titleImageHeighRatio = CGFloat(7)
    private let titleImageWidthRatio = CGFloat(0.8)
    

    private var nextButton: NextPageButton =  NextPageButton(title: "다음 페이지로",
                                                             width: UIScreen.screenWidth/1.2,
                                                             height: UIScreen.screenHeight/15)
    var body: some View {
        VStack {
            (Text("오늘을 ")
             +
             Text("기록할 사진")
                .bold()
             +
             Text("이 있나요?")
            )
            .font(.title)
            .padding(.bottom, 20)
            
            PhotosPicker(selection: $picker.imageSelection) {
                if let image = picker.image {
                    image
                        .resizable()
                        .scaledToFit()
                        .padding(.all, 10)
                } else {
                    Image("add-climbing-photo")
                }
            }
        }
        .overlay(
            self.nextButton
                .offset(CGSize(width: 0, height: UIScreen.screenHeight/4))
        )
        
    }
}

struct AddPhotoView_Previews: PreviewProvider {
    static var previews: some View {
        AddPhotoView()
    }
}

