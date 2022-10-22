//
//  AddPhotoButton.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2022/10/22.
//

import SwiftUI
import PhotosUI

struct AddPhotoButton: View {
    let imageName: String
    let width: CGFloat
    let height: CGFloat
    let maxSelectionCount: Int = 1
    
    @State var selectedPhotos: [PhotosPickerItem] = []
    @State var data: Data?
    
    var body: some View {
        VStack {
            PhotosPicker(selection: $selectedPhotos,
                         maxSelectionCount: maxSelectionCount,
                         matching: .images) {
                
                if let data = self.data,
                   let selectedImage = UIImage(data: data) {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .frame(width: self.width, height: self.height)
                } else {
                    Image(imageName)
                        .resizable()
                        .frame(width: self.width, height: self.height)
                }
            }.onChange(of: selectedPhotos) { photos in
                guard let item = self.selectedPhotos.first else {
                    return
                }
                
                item.loadTransferable(type: Data.self) { result in
                    switch result {
                    case .success(let data):
                        if let data = data {
                            self.data = data
                        }
                    case .failure(let failure):
                        print(failure)
                    }
                }
            }
        }
    }
}

struct AddPhotoButton_Previews: PreviewProvider {
    static var previews: some View {
        AddPhotoButton(imageName: "add-climbing-photo",
                       width: CGFloat(80),
                       height: CGFloat(80))
    }
}
