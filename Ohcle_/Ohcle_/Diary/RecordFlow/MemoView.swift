//
//  MemoView.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2022/10/29.
//

/*
 
 1. 메모에 기록홀더 색
 2. 홀더를 랜덤으로 보여줄것이냐 -> 선만보이도록????
 -> 홀더모양(선) -> 선안을 초록색으로 채우는 -> 하루정도 한 번 시도
 3. 모양별로 색을 다 가져오기 -> 모양 : 최소 7개 -> 70개 -> `490kb`
 
 --
 4. 이후 버전에서 할 일 : 아이클라우드 동기화, 자주가는 장소 태그 하기
 */


import SwiftUI


struct MemoView: View {
    @State private var typedText: String = DiaryManager.shared.temporaryMemo
    @State private var memoState: MemoState = .save
    @State private var textStyle = UIFont.TextStyle.body
    
    private let finalScoreNumber: Int = DiaryManager.shared.temporaryScore
    private let mapImageName: String = "map"
    private let climbingLocationPlaceHolder: String = "클라임웍스 클라이밍"
    private let memoBackgroundColor = Color("DiaryBackgroundColor")

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Circle()
                .fill(.red)
                .frame(width: 30, height: 30)
                .padding(.top, 5)
            
            Text("\(OhcleDate.currentDate)")
                .font(.title)
            
            HStack(spacing: 5) {
                Image(systemName: mapImageName)
                Text(climbingLocationPlaceHolder)
                    .font(.body)
                    .foregroundColor(.gray)
            }
            .padding(.bottom, -5)
            
            HStack() {
                ScoreStar(rating: .constant(finalScoreNumber))
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
                    Image(
                    DiaryManager.shared.temporaryPhotoAddress)
                    Spacer()
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
                MemoButton()
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
    static var previews: some View {
        MemoView()
    }
}



