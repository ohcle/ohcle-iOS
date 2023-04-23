//
//  MemoView.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2022/10/29.
//

import SwiftUI


struct MemoView: View {
    private let mapImageName: String = "map"
    private let memoBackgroundColor = Color("DiaryBackgroundColor")
    
    @EnvironmentObject var currentPageType: MyPageType
    @Environment(\.managedObjectContext) var managedObjectContext

    @State private var climbingLocationPlaceHolder: String = "클라임웍스 클라이밍"
    
    @State private var typedText: String =  DataController.shared.temMemo
    @State private var color = Color.convert(from: DataController.shared.temLevel)
    @State private var date = DataController.shared.temDate
    @State private var score = DataController.shared.temScore
    @State private var photoData = DataController.shared.temPhoto
    
    @State var diary: Diary?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Circle()
                .fill(color)
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
                        self.diary?.memo = typedText
                    }
            }
            
            Spacer()
            HStack {
                Spacer()
                MemoButton() {
                    if let diary = diary {
                        DataController.shared.updateDiary(diary)
                    } else {
                        DataController.shared.saveTemporaryMemo(typedText)
                        DataController.shared.saveDiary(managedObjectContext)
                        currentPageType.type = .done
                        currentPageType.type = .calender
                        self.saveDiaryToServer(DataController.shared.temDate, DataController.shared.temScore, DataController.shared.temLevel, DataController.shared.temPhoto, DataController.shared.temMemo)
                        DataController.shared.clearTemDiary()
                        
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
    }
}


extension MemoView {
    func getLevel(_ levelStr: String) -> Int {
        let levelDict = ["red"              : 1
                         ,"orange"          : 2
                         ,"yellow"          : 3
                         ,"green"           : 4
                         ,"holder-darkblue" : 5
                         ,"blue"            : 6
                         ,"purple"          : 7
                         ,"black"           : 8
                         ,"holder-lightgray": 9
                         ,"holder-darkgray" : 10
        ]
        return levelDict[levelStr] ?? 0
    }
    
    func saveDiaryToServer(_ date: String, _ score: Int16, _ level: String, _ photo: Data, _ memo: String ) {
         
        let urlStr = "https://api-gw.todayclimbing.com/" +  "v1/climbing/"
        guard let url = URL(string: urlStr) else {
            print("Fail to InitURL")
            return
        }
        var request = URLRequest(url: url)
        let parameters = ["where": ["name": "test"
                                   ,"address": "address"
                                   ,"latitude":37.13
                                   ,"longitude":127.234
                                   ]
                          ,"when":date
                          ,"level": self.getLevel(level)
                          ,"score":score
                          ,"memo":memo
                          
                        ] as [String : Any]
        
        
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
                
            }
        }
        task.resume()
        
    }

}

struct MemoView_Previews: PreviewProvider {
    static let mocRecorded = RecordedMemo(id:0,date: "dd", location: "dd", level: "Ddd", score: 2, imageData: Data(), memo: "ddd")
    @State static var isEdited: Bool = false
    static var previews: some View {
        MemoView()
    }
}
