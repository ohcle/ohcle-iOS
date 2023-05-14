//
//  NewMemoView.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2023/05/07.
//

import SwiftUI

extension String {
    func convertToTrimmedLiteral() -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = inputFormatter.date(from: self) else {
            fatalError("Failed to parse date")
        }
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy년 M월 d일"
        let formattedDate = outputFormatter.string(from: date)
        return formattedDate
    }
}

struct NewMemoView: View {
    private let mapImageName: String = "map"
    private let memoBackgroundColor = Color("DiaryBackgroundColor")
    
    @EnvironmentObject var currentPageType: MyPageType
    @Binding var isModalView: Bool
    
    @Binding var id: Int
    @State private var climbingLocation = "클라임웍스 클라이밍"
    @State private var typedText = ""
    @State private var levelColor = Color.yellow
    @State private var date = "2020-02-02"
    @State private var score = 0
    @State private var photoData = Data()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Circle()
                .fill(levelColor)
                .frame(width: 30, height: 30)
                .padding(.top, 20)
            
            Text("\(date.convertToTrimmedLiteral())")
                .font(.title)
            
            HStack(spacing: 5) {
                Image(systemName: mapImageName)
                Text(climbingLocation)
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
            }
            
            Spacer()
            HStack {
                Spacer()
                MemoButton() {
                    Task {
                        let levelColorString = self.levelColor.climbingLevelName
                        let levelColorNumber = HolderColorNumber(rawValue: levelColorString)?.colorNumber
                        
                        if let levelColorNumber = levelColorNumber {

                        }
                        
                        let patchData = PatchData(whereID: self.id, when: self.date,
                                                  level: 3, score: Double(self.score),
                                                  memo: self.typedText, picture: [""],
                                                  video: "", tags: [""])
                        await saveDiary(patchData)
                       
                    }
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
            let data = await requestDetailMemo(id: self.id)
            decodeData(data ?? Data())
        }
    }
}

struct PatchData: Codable {
    let whereID: Int
    let when: String
    let level: Int
    let score: Double
    let memo: String
    let picture: [String]
    let video: String?
    let tags: [String]?
}

extension NewMemoView {
    private func saveDiary(_ diary: PatchData) async {
        let urlStr = "https://api-gw.todayclimbing.com/v1/climbing/\(diary.whereID)/"
        
        guard let url = URL(string: urlStr) else {
            print("Fail to InitURL")
            return
        }
        
        do {
            var request = try URLRequest(url: url, method: .patch)
            let parameters: [String: Any?] = ["where": ["id": diary.whereID],
                                              "when": diary.when,
                                              "level": diary.level,
                                              "score": diary.score,
                                              "memo": diary.memo,
                                              "picture": [],
                                              "video": nil,
                                              "tags": nil]
            
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
    
    private func requestDetailMemo(id: Int) async -> Data? {
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
            let decodedData = try JSONDecoder().decode(DetailClimbingModel.self, from: data)
            
            let levelColorString = HolderColorNumber(rawValue: "\(decodedData.level)") ?? HolderColorNumber.nonSelected
            print(levelColorString.rawValue)
            
            let levleColor = Color.convert(from: levelColorString.colorName)
            print(levleColor)
            
            self.levelColor = levleColor
            self.date = decodedData.when
            self.typedText = decodedData.memo
            self.score = Int(decodedData.score)
            self.climbingLocation = decodedData.where.name
            
            print(self.date, self.score, self.typedText)
        } catch {
            print(error)
        }
    }
    
}

struct NewMemoView_Previews: PreviewProvider {
    @State static var isModal: Bool = false
    @State static var id: Int = 21
    static var previews: some View {
        NewMemoView(isModalView: $isModal, id: $id)
    }
}
