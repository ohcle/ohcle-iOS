//
//  MemoView.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2022/10/29.
//

import SwiftUI


struct MemoView: View {
    @State private var typedText: String = ""
    private let mapImageName: String = "map"
    
    private let climbingLocationPlaceHolder: String = "클라임웍스 클라이밍"
    private let memoBackgroundColor = Color("DiaryBackgroundColor")
    
    private let color = Color.convert(from: DataController.shared.temLevel)
    private let date = DataController.shared.temDate
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Circle()
                .fill(color)
                .frame(width: 30, height: 30)
                .padding(.top, 5)
            
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
                ScoreStar(rating: .constant(Int(DataController.shared.temScore)))
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



