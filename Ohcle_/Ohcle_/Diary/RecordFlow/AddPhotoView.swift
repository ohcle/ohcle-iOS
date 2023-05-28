//
//  AddPhotoView.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2022/10/22.
//

import SwiftUI
import PhotosUI

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
        .onAppear {
            if !CalendarDataManger.shared.record.photo.isEmpty {
                selectedImage = UIImage(data: CalendarDataManger.shared.record.photo)
                self.nextButton.userEvent.inform()
            }
            
            self.nextButton.userEvent.nextButtonTouched = {
                
            }

        }
    }
        
}

// MARK: Photo Picker
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

                guard var imgData = image.jpegData(compressionQuality: 1.0) else { return }
                print(imgData.count)
                while (imgData.count > 3*1024*1024) { //이미지의 최대 크기 3MB로 제한
                    imgData = image.jpegData(compressionQuality: 0.5) ?? Data()
                }
                print("\( imgData.count / (1024*1024)) MB")
                
                // Save Img in Server
                self.postImage(imgData) { (data, response) in
                    let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]

                    if response.statusCode == 200 {
                        if let filename = json?["filename"] as? String {
                            CalendarDataManger.shared.record.saveTemporaryPhotoData(imgData)
                            CalendarDataManger.shared.record.saveTemporaryPhotoName(filename)
                            self.parent.selectedImage = image
                        }

                    } else {
                        print("Image 저장실패")
                    }
                    
                }

                
                
            }
            parent.isPresented = false
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.isPresented = false
        }
        
        
        func postImage(_ imgData: Data, completion: @escaping (Data,HTTPURLResponse) -> Void ) {
            let urlStr = "https://api-gw.todayclimbing.com/" +  "v1/media/image"
            guard let url = URL(string: urlStr) else {
                print("Fail to InitURL")
                return
            }
            var request = URLRequest(url: url)
            let parameters = ["image":imgData.base64EncodedString()]
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
            
            let session = URLSession.shared
            let task = session.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    return
                }
                
                if let data = data, let response = response as? HTTPURLResponse {
                    print("Status code: \(response.statusCode)")
                    print("Response data: \(String(data: data, encoding: .utf8) ?? "")")
                    
                    completion(data,response)
                }
                
            }
            task.resume()
        }
        
    }
}


struct AddPhotoView_Previews: PreviewProvider {
    static var previews: some View {
        AddPhotoView()
    }
}

