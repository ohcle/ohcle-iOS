//
//  AddPhotoView.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2022/10/22.
//

import SwiftUI
import PhotosUI

@available(iOS 16.0, *)
struct AddPhotoView: View {
    private let titleImageHeighRatio = CGFloat(7)
    private let titleImageWidthRatio = CGFloat(0.8)

    private var nextButton: NextPageButton =  NextPageButton(title: "다음",
                                                             width: UIScreen.screenWidth/1.2,
                                                             height: UIScreen.screenHeight/15)
    @State private var isShowingGalleryPicker = false
    @State private var selectedImage: UIImage?
    @State private var showAlert = false
    
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
            
            if #available(iOS 15.0, *) {
                PhotosPicker(selection: $picker.imageSelection, matching: .any(of: [.images, .not(.livePhotos)])) {
                    if let image = picker.image {
                        image
                            .resizable()
                            .scaledToFit()
                            .padding(.all, 10)
                    } else {
                        Image("add-climbing-photo")
                            .padding(.top, 10)
                    }
                }
            } else {
                // Fallback on earlier versions
                if let image = selectedImage {
                    Image(uiImage: selectedImage ?? UIImage())
                        .resizable()
                        .scaledToFit()
                        .padding(.all, 10)
                        .onTapGesture {
                            isShowingGalleryPicker = true
                        }
                } else {
                    Image("add-climbing-photo")
                        .padding(.top, 10)
                        .onTapGesture {
                            isShowingGalleryPicker = true
                        }
                }
                
                if isShowingGalleryPicker {
                    GalleryPickerView(isPresented: $isShowingGalleryPicker, selectedImage: $selectedImage)
                        .frame(maxHeight: UIScreen.screenHeight/2) // view의 반절에만 나오도록 설정
                        .edgesIgnoringSafeArea(.bottom) // Safe Area를 무시하여 밑에만 나오도록 설정
                        .background(.gray)
                }
            }
        }
        .overlay(
            Group {
                if !self.isShowingGalleryPicker {
                    self.nextButton
                        .offset(CGSize(width: 0, height: UIScreen.screenHeight/4))
                }
            }
        )
    }
        
}
struct AddPhotoView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 16.0, *) {
            AddPhotoView()
        } else {
            // Fallback on earlier versions
        }
    }
}


@available(iOS 16.0, *)
extension PhotosPicker {
    init(selection: Binding<PhotosPickerItem?>, matching filter: PHPickerFilter? = nil, preferredItemEncoding: PhotosPickerItem.EncodingDisambiguationPolicy = .automatic, @ViewBuilder label: () -> Label, closure: () -> ()) {
        self.init(selection: selection, label: label)
        closure()
    }
}

struct GalleryPickerView: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    @Binding var selectedImage: UIImage?
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        // No need to update the view controller
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: GalleryPickerView
        
        init(_ parent: GalleryPickerView) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
                
                guard var imgData = image.jpegData(compressionQuality: 1.0) else { return }
                print(imgData.count)
                
                while (imgData.count > 3*1024*1024) { //이미지의 최대 크기 3MB로 제한
                    imgData = image.jpegData(compressionQuality: 0.5) ?? Data()
                }
                
                print("\( imgData.count / (1024*1024)) MB")
                
                DataController.shared.saveTemporaryPhotoData(imgData)
                parent.isPresented = false
            }
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.isPresented = false
        }
    }
}
