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
    let selectedImageWidth: CGFloat
    let selectedImgeHieght: CGFloat
    private let maxSelectionCount: Int = 1
    
    @State private var selectedPhotos: [PhotosPickerItem] = []
    @State private var data: Data?
    @Binding var isSelected: Bool
    
    var body: some View {
        VStack {
            Button {
            } label: {
                PhotosPicker(selection: $selectedPhotos,
                             maxSelectionCount: maxSelectionCount,
                             matching: .images) {
                    if let data = self.data,
                       let selectedImage = UIImage(data: data) {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .frame(width: self.selectedImageWidth, height: self.selectedImgeHieght)
                    } else {
                        Image(imageName)
                    }
                }.onChange(of: selectedPhotos) { photos in
                            Debouncer(delay: 0.3).run {
                                self.isSelected.toggle()
                            }

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
}
