//
//  DiaryList.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2022/11/12.
//

import SwiftUI

struct RecordedMemo: Hashable {
    let date: String
    let location:String
    let level: String
    let score: String
    let image: String
    let id: UUID
}

struct DiaryList: View {
    private let listSpacing: CGFloat = 30
    let memos: [RecordedMemo] = [
        RecordedMemo(date: "2022.01.22", location: "더클 양재", level: "빨강", score: "4.5", image: "main-logo", id: UUID()),
        RecordedMemo(date: "2022.01.23", location: "더클 연남", level: "노랑", score: "2.0", image: "main-logo", id: UUID()),
        RecordedMemo(date: "2022.01.23", location: "더클 서울대", level: "노랑", score: "2.0", image: "main-logo", id: UUID()),
        RecordedMemo(date: "2022.01.23", location: "더클 수원", level: "노랑", score: "2.0", image: "main-logo", id: UUID())
    ]
    
    
    private let column = [
        GridItem(.flexible(minimum: 250))
    ]
    
    private func get() {
                guard let url = URL(string: "http://ec2-3-37-182-202.ap-northeast-2.compute.amazonaws.com/v1/climbing?started_at=2022-12-01&ended_at=2023-01-31") else {
                    return
                }

                do {
                    var request = try URLRequest(url: url, method: .get)
                    
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    request.setValue("token fea094af21c868fb447799bdc405f0ec316889da", forHTTPHeaderField: "Authorization")
                    
                    URLSession.shared.dataTask(with: request) { data, response, error in
                        if let response = response as? HTTPURLResponse {
                            print(response.statusCode)
                        }
                        print(error)
                        if let data = data {
                            do {
                                let decodedData = try JSONDecoder().decode([MemoModel].self, from: data)
                                print(decodedData)
                            } catch {
                                print(error)
                            }
                          
                        }

                    }.resume()
      
                    
                } catch {
                    print(error)
                }
    }
    
    var body: some View {
        VStack(spacing: listSpacing) {
            DiaryHeader()
            ScrollView(.vertical) {
                LazyVGrid(columns: column,
                          alignment: .leading,
                          spacing: listSpacing) {
                    ForEach(memos, id: \.self) { memo in
                        DiaryListViewGridItem(date: memo.date,
                                              location: memo.location,
                                              level: memo.level,
                                              score: memo.score,
                                              memoImageName: memo.image)
                        .padding(.leading, 30)
                    }
                }
            }
        }.onTapGesture {
            get()

        }
        
    }
}
struct example_Previews: PreviewProvider {
    static var previews: some View {
        DiaryList()
    }
}


//struct MemoModel: Decodable {
//    let memo: [Detail]
    
    struct MemoModel: Decodable {
        let id: Int?
        let bold: Int?
        let location : [Float?]
        let level_color: String?
        let created_at: String?
        let modified_at : String?
        let image: String?
        let review: String?
        let address: String?
        let level: String?
        let grade: Int?
        let user: Int?
    }
//}
