//
//  AddPhotoView.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2022/10/22.
//

import SwiftUI
import PhotosUI

struct AddPhotoView: View {
    @ObservedObject var picker = ClimbingImagePicker()
    
    private let titleImageHeighRatio = CGFloat(7)
    private let titleImageWidthRatio = CGFloat(0.8)
    
    
    private var nextButton: NextPageButton =  NextPageButton(title: "다음 페이지로",
                                                             width: UIScreen.screenWidth/1.2,
                                                             height: UIScreen.screenHeight/15)
    
    @State private var isShowingGalleryPicker = false
    @State private var selectedImage: UIImage?
    @State private var showAlert: Bool = false
    
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
            
            HStack {
                Image("add-climbing-photo2")
//                    .padding(.top, 10)
                    .onTapGesture {
                        if selectedImage == nil {
                            isShowingGalleryPicker = true
                        } else {
                            showAlert = true
                        }
                        
                    }
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text(""), message: Text("최대 이미지는 1개까지 업로드 가능합니다."), dismissButton: .default(Text("확인")))
                    }
                
                if selectedImage != nil {
                    ZStack (alignment: Alignment(horizontal: .trailing, vertical: .top)) {
                        
                        Image(uiImage: selectedImage ?? UIImage())
                            .resizable()
//                            .scaledToFit()
//                            .aspectRatio(contentMode: .fill)
//                            .padding(.all, 10)
                            .frame(width: 64, height: 64)

                        Button {
                            selectedImage = nil
                            CalendarDataManger.shared.record.clearTemporaryPhotoData()
                        } label: {
                            Image(systemName: "xmark")
                                .foregroundColor(.white)
                                .padding(.all, 10)
                                .background(.gray)
                                .frame(width: 24, height: 24)
                                .cornerRadius(12)
                        }
                    }
//                        .frame(maxHeight: UIScreen.screenHeight/2)
                }

            }
            
            
            if isShowingGalleryPicker {
                GalleryPickerView(isPresented: $isShowingGalleryPicker, selectedImage: $selectedImage)
                    .frame(maxHeight: UIScreen.screenHeight/2) // view의 반절에만 나오도록 설정
                    .edgesIgnoringSafeArea(.bottom) // Safe Area를 무시하여 밑에만 나오도록 설정
                    .background(.gray)
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
        .onChange(of: selectedImage) { _ in
            
            if selectedImage == nil {
                self.nextButton.deactivateNextButton()
            } else {
                self.nextButton.activateNextButton()
            }
        }
    }
}

struct AddPhotoView_Previews: PreviewProvider {
    static var previews: some View {
        AddPhotoView()
    }
}


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
                CalendarDataManger.shared.record.saveTemporaryPhotoData(imgData)
            }
            parent.isPresented = false
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.isPresented = false
        }
    }
}
