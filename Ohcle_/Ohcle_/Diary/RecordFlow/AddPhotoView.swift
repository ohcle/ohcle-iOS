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
    @State private var isImageSelected: Bool = false
    
    private let titleImageHeighRatio = CGFloat(7)
    private let titleImageWidthRatio = CGFloat(0.8)
    
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
                           selectedImageWidth: self.titleSize.width * titleImageWidthRatio,
                           selectedImgeHieght : self.titleSize.height * titleImageHeighRatio,
                           isSelected: $isImageSelected)
            .onChange(of: self.isImageSelected) { newValue in
                Debouncer(delay: 1.0).run {
                    withAnimation {
                        nextPage.type = .memo
                    }
                }
            }
        }
    }
}

struct AddPhotoView_Previews: PreviewProvider {
    static var previews: some View {
        AddPhotoView()
    }
}

