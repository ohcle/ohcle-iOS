//
//  NewMemoView.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2023/05/07.
//

import SwiftUI

struct NewMemoView: View {
    private let mapImageName: String = "map"
    private let memoBackgroundColor = Color("DiaryBackgroundColor")
    
    @EnvironmentObject var currentPageType: MyPageType
    @Binding var isModalView: Bool
    
    @State var id: Int
    @State private var climbingLocationPlaceHolder: String = "클라임웍스 클라이밍"
    
    @State private var typedText: String = ""
    @State private var levelColor = Color.yellow
    @State private var date = ""
    @State private var score = 0
    @State private var photoData = Data()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Circle()
                .fill(levelColor)
                .frame(width: 30, height: 30)
                .padding(.top, 20)
            
            Text("\(date)")
                .font(.title)
            
            HStack(spacing: 5) {
                Image(systemName: mapImageName)
                Text(climbingLocationPlaceHolder)
                    .font(.body)
                    .foregroundColor(.gray)
            }
            .padding(.bottom, -5)
            
            HStack() {
                ScoreStar(rating: .constant(Int(score)))
            }
            
            VStack(alignment: .leading) {
                Text("MEMO")
                    .font(.title)
                    .bold()
                    .padding(.top, 10)
                
                Divider()
                    .frame(minHeight: 2)
                    .overlay(Color.black)
                    .padding(.top, -10)
                
                if photoData.isEmpty == false {
                    HStack {
                        Spacer()
                        Image(uiImage: UIImage(data: DataController.shared.temPhoto) ?? UIImage())
                            .resizable()
                            .scaledToFit()
                        Spacer()
                    }
                }
                
                TextEditor(text: $typedText)
                    .scrollContentBackground(.hidden)
                    .background(memoBackgroundColor)
                    .foregroundColor(Color.black)
                    .lineSpacing(5)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .onChange(of: typedText) { newValue in
                        
                    }
            }
            
            Spacer()
            HStack {
                Spacer()
                MemoButton() {
                    
                }
                
                Spacer()
            }
            Spacer()
        }
        
        .padding(.leading, 30)
        .padding(.trailing, 30)
        .onAppear() {
            UITextView.appearance().backgroundColor = .clear
        }
        
        .task {
            print(self.id)
            let data = await requestDetailMemo(id: self.id)
            decodeData(data ?? Data())
        }
    }
}


extension NewMemoView {
    func saveDiary(id: Int) async {
        let urlStr = "https://api-gw.todayclimbing.com/v1/climbing/\(id)/"
        
        guard let url = URL(string: urlStr) else {
            print("Fail to InitURL")
            return
        }
        
        do {
            var request = try URLRequest(url: url, method: .post)
            let parameters = ["where": 0, ]
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let response = response as? HTTPURLResponse,
               response.statusCode != 200 {
                print("Status code: \(response.statusCode)")
                print("Response data: \(String(data: data, encoding: .utf8) ?? "")")
            }
        } catch {
            print(error)
        }
    }
    
    func requestDetailMemo(id: Int) async -> Data? {
        let urlStr = "https://api-gw.todayclimbing.com/v1/climbing/\(id)"
        
        guard let url = URL(string: urlStr) else {
            print("Fail to InitURL")
            return nil
        }
        
        do {
            var request = try URLRequest(url: url, method: .get)
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let response = response as? HTTPURLResponse,
               response.statusCode != 200 {
                print("Status code: \(response.statusCode)")
                print("Response data: \(String(data: data, encoding: .utf8) ?? "")")
            }
            return data
        } catch {
            print(error)
        }
        
        return nil
    }
    
    private func decodeData(_ data: Data) {
        do {
            let decodedData = try JSONDecoder().decode(ClimbingData.self, from: data)
            
            let levelColorString = HolderColorNumber(rawValue: "\(decodedData.level)")
            let levleColor = Color.convert(from: levelColorString?.rawValue ?? "red")
            
            self.levelColor = levleColor
            self.date = decodedData.when
            self.typedText = decodedData.memo
            self.score = Int(decodedData.score)
            
            print(decodedData.when)
            //            self.photoData = decodedData.picture
        } catch {
            print(error)
        }
    }
    
}

struct NewMemoView_Previews: PreviewProvider {
    @State static var isModal: Bool = false
    static var previews: some View {
        NewMemoView(isModalView: $isModal, id: 0)
    }
}
