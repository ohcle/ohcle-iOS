//
//  EditMemoPickerView.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2023/05/28.
//

import SwiftUI

struct PickerView: View {
    @Binding var isShowingGalleryPicker: Bool
    @State private var showAlert: Bool = false

    @Binding var selectedImage: UIImage?

    var body: some View {
        VStack {
            HStack {
                Image("add-climbing-photo2")
                    .onTapGesture {
                        if selectedImage == nil {
                            withAnimation {
                                isShowingGalleryPicker = true
                            }
                        } else {
                            showAlert = true
                        }
                    }
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text(""),
                              message: Text("최대 이미지는 1개까지 업로드 가능합니다."),
                              dismissButton: .default(Text("확인")))
                    }
                
                if selectedImage != nil {
                    ZStack (alignment: Alignment(horizontal: .trailing, vertical: .top)) {
                        
                        Image(uiImage: selectedImage ?? UIImage())
                            .resizable()
                            .frame(width: 64, height: 64)

                        Button {
                            selectedImage = nil

                        } label: {
                            Image(systemName: "xmark")
                                .foregroundColor(.white)
                                .padding(.all, 10)
                                .background(.gray)
                                .frame(width: 24, height: 24)
                                .cornerRadius(12)
                        }
                    }
                }
            }
        }
    }
}

extension View {
    public func asUIImage() -> UIImage {
        let controller = UIHostingController(rootView: self)
        
        controller.view.backgroundColor = .clear
        controller.view.frame = CGRect(x: 0, y: CGFloat(Int.max), width: 1, height: 1)
        UIApplication.shared.windows.first!.rootViewController?.view.addSubview(controller.view)

        let size = controller.sizeThatFits(in: UIScreen.main.bounds.size)
        controller.view.bounds = CGRect(origin: .zero, size: size)
        controller.view.sizeToFit()
        
        let image = controller.view.asUIImage()
        controller.view.removeFromSuperview()
        return image
    }
}

extension UIView {
    public func asUIImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
