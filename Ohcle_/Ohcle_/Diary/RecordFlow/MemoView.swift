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
                
                HStack {
                    Spacer()
                    Image(uiImage: UIImage(data: DataController.shared.temPhoto) ?? UIImage())
                        .resizable()
                        .scaledToFit()
                    Spacer()
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

struct MemoView_Previews: PreviewProvider {
    static let mocRecorded = RecordedMemo(date: "dd", location: "dd", level: "Ddd", score: 2, imageData: Data(), memo: "ddd")
    @State static var isEdited: Bool = false
    static var previews: some View {
        MemoView()
    }
}



