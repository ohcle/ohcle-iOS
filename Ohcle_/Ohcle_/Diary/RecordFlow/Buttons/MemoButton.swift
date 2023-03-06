//
//  OhcleButton.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2022/11/12.
//

import SwiftUI
import Foundation

enum FatalError: Error {
    case invalidStatusCode
}

enum MemoState: String {
    case edit = "수정하기"
    case save = "저장하기"
}

struct MemoButton: View {
    @State private var title: String = MemoState.save.rawValue
    private let memoButtonColor: String = "editButton"
    private let memoButtonRadius: CGFloat = 8.0
    @State var action: (() -> ())?
    
    var body: some View {
        Button {
            action?()
        } label: {
            Text(title)
                .fontWeight(.bold)
                .font(.title3)
                .padding()
                .background(Color(memoButtonColor))
                .cornerRadius(memoButtonRadius)
                .foregroundColor(.white)
        }
    }
    
//    func requestSave() async throws {
//        guard let url = URL(string: "http://ec2-3-37-182-202.ap-northeast-2.compute.amazonaws.com/v1/climbing") else {
//            return
//        }
//
//        let image = UIImage(named: "main_logo")
//        guard let incodedImage = image?.jpegData(compressionQuality: 1)?.base64EncodedString() else {
//            return
//        }
//
//        var request = try URLRequest(url: url, method: .post)
//
//        let parameters: [String: Any] = ["climbing_at": "2023-01-01", "image": incodedImage ,"review": "테스트 좀 해보자", "level": "BLUE", "grade": 1, "address": "서울숲 클라이밍"]
//
//        request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.setValue("token fea094af21c868fb447799bdc405f0ec316889da", forHTTPHeaderField: "Authorization")
//
//        let (_, response): (Data, URLResponse) = try await URLSession.shared.data(for: request)
//
//        let validStatusCode = (200...299)
//
//        guard let statusCode = (response as? HTTPURLResponse)?.statusCode,
//              (validStatusCode).contains(statusCode) else {
//            throw FatalError.invalidStatusCode
//        }
//    }
    
    func changeButtonTitleToEdit() {
        self.title = MemoState.edit.rawValue
    }
}

struct OhcleButton_Previews: PreviewProvider {
    static var previews: some View {
        MemoButton()
    }
}
