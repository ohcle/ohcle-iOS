//
//  MemoView.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2022/10/29.
//

import SwiftUI

struct TextView: UIViewRepresentable {
    @Binding var text: String
    @Binding var textStyle: UIFont.TextStyle
    @EnvironmentObject var nextPage: MyPageType
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        
        textView.font = UIFont.preferredFont(forTextStyle: textStyle)
        textView.autocapitalizationType = .sentences
        textView.isSelectable = true
        textView.isUserInteractionEnabled = true
        
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
        uiView.font = UIFont.preferredFont(forTextStyle: textStyle)
    }
}

struct MemoView: View {
    @State private var typedText: String = "Ya~~~"
    @State private var memoState: MemoState = .save
    @State private var textStyle = UIFont.TextStyle.body
    
    private let finalScoreNumber: Int = 4
    private let mapImageName: String = "map"
    private let climbingLocationPlaceHolder: String = "클라임웍스 클라이밍"
    private let scoreNubmer: Int = 3
    private let memoBackgroundColor = Color("DiaryBackgroundColor")
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Circle()
                .fill(.red)
                .frame(width: 30, height: 30)
                .padding(.top, 5)
            
            Text("\(currentDate)")
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
                
                TextEditor(text: $typedText)
                    .foregroundColor(Color.black)
                    .lineSpacing(5)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .border(Color.gray, width: 1)
                    .background(memoBackgroundColor)
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



