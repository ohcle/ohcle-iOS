////
////  AddPhotoButton.swift
////  Ohcle_
////
////  Created by Do Yi Lee on 2022/10/22.
////
//
//import SwiftUI
//import PhotosUI
//
//
//struct AddPhotoButton: View {
//    let imageName: String
//    let selectedImageWidth: CGFloat
//    let selectedImgeHieght: CGFloat
//    private let maxSelectionCount: Int = 1
//    
//    @ObservedObject var picker = ClimbingImagePicker()
//    
//    var body: some View {
//        VStack {
//            PhotosPicker(selection: $picker,
//                         maxSelectionCount: maxSelectionCount,
//                         matching: .any(of: [.images, .not(.livePhotos)])) {
////                if let data = self.data,
////                   let selectedImage = UIImage(data: data) {
////                    Image(uiImage: selectedImage)
////                        .resizable()
////                        .frame(width: self.selectedImageWidth, height: self.selectedImgeHieght)
////                } else {
////                    Image(imageName)
////                }
//            }
////
////                         .onChange(of: $picker) { photo in
////                             Task {
////                                 if let data = try? await photo.first?.loadTransferable(type: Data.self) {
////                                     self.data = data
////                                 }
////                             }
////                         }
//        }
//    }
//}
