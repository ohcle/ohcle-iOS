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
    @Binding var isModal: Bool
    
    @State private var climbingLocationPlaceHolder: String = CalendarDataManger.shared.record.climbingLocation.name
    @State private var typedText: String =  CalendarDataManger.shared.record.temMemo
    @State private var color = Color.convert(from: CalendarDataManger.shared.record.temLevel)
    @State private var date = CalendarDataManger.shared.record.temDate
    @State private var score =  CalendarDataManger.shared.record.temScore
    @State private var photoData =  CalendarDataManger.shared.record.temPhoto
    
    @State var diary: Diary?
    @Binding var selectedTab: Int
    
    @State private var showAlert = false
    @State private var alertMsg  = ""
    
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
                        Image(uiImage: UIImage(data: CalendarDataManger.shared.record.temPhoto) ?? UIImage())
                            .resizable()
                            .scaledToFit()
                        Spacer()
                    }
                }
                
                ZStack(alignment: Alignment(horizontal: .leading, vertical: .top)) {

                    TextEditor(text: $typedText)
                        .scrollContentBackground(.hidden)
                        .background(memoBackgroundColor)
                        .foregroundColor(Color.black)
                        .lineSpacing(5)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .onChange(of: typedText) { newValue in
                            print(newValue.count)
                            
                            if newValue.count >= 100 {
                                typedText = String(typedText.prefix(100))
                                
                                alertMsg = "최대글자는 100자 제한입니다."
                                showAlert = true
                            }
                            self.diary?.memo = typedText
                        }
                    
                    
                    if typedText.isEmpty {
                        Text("오늘의 클라이밍은 어땠나요?")
                            .foregroundColor(.gray)
                            .lineSpacing(5)
                            .padding(.top,10)
                    }

                }

            }
            
            Spacer()
            HStack {
                Spacer()
                MemoButton() {
                    if let diary = diary {
                        CalendarDataManger.shared.updateDiary(diary: diary)
                       
                    } else {
                        CalendarDataManger.shared.record.saveTemporaryMemo(typedText)
                        currentPageType.type = .done
                        currentPageType.type = .calender
                        self.saveDiaryToServer()
                        CalendarDataManger.shared.record.clearRecord()
                        
                        self.selectedTab = 1
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
        
        .alert(isPresented: $showAlert) {
            Alert(title: Text(alertMsg))
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
    
    func saveDiaryToServer() {
        
        let date = CalendarDataManger.shared.record.date
        let score = CalendarDataManger.shared.record.score
        let level = CalendarDataManger.shared.record.level
//        let photo = CalendarDataManger.shared.record.photo
        let photoNm = CalendarDataManger.shared.record.photoName
        let memo = CalendarDataManger.shared.record.memo
         
        let urlStr = "https://api-gw.todayclimbing.com/" +  "v1/climbing/"
        guard let url = URL(string: urlStr) else {
            print("Fail to InitURL")
            return
        }
        var request = URLRequest(url: url)
        let parameters = ["where": ["id": 1
                                   ]
                          ,"when":date
                          ,"level": self.getLevel(level)
                          ,"score":score
                          ,"memo":memo
                          ,"picture": [photoNm]
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
    @State static var isModal: Bool = false
    @State static var selectedTab:Int = 2

    static var previews: some View {
        MemoView(isModal: $isModal, selectedTab: $selectedTab)
    }
}
