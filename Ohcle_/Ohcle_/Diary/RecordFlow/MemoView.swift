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
    @State var typedText: String = "끝내줌"
    @State var placeHodler = "오늘의 클라이밍은 어땠나요?"
    @State private var memoState: MemoState = .save
    @State var textStyle = UIFont.TextStyle.body
    
    @State private var locationLetterSize: CGSize = CGSize()
    private let finalScoreNumber: Int = 4
    private let mapImageName: String = "map"
    private let climbingLocationPlaceHolder: String = "클라임웍스 클라이밍"
    private let scoreNubmer: Int = 3
    
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
            
            ZStack(alignment: .leading) {
                Text("MEMO")
                    .font(.title)
                    .bold()
                    .zIndex(10)
                    .offset(x: 0, y: -216)
                
                Rectangle()
                    .size(width: 330, height: 1)
                    .offset(x: 0, y: 70)
                
                TextView(text: $typedText,
                         textStyle: $textStyle)
                .offset(x: 0, y: 80)
            }
            
            Button() {
                //Save Data to CoreData Storage
                
            } label: {
                Text("저장하기")
                    .fontWeight(.bold)
                    .font(.title3)
                    .padding()
                    .background(Color("editButton"))
                    .cornerRadius(8)
                    .foregroundColor(.white)
            }
        }
        .padding(.leading, 30)
        .padding(.trailing, 30)
    }
    //}
}

struct MemoView_Previews: PreviewProvider {
    @State var example2 = "dd"
    
    static var previews: some View {
        MemoView()
    }
}



