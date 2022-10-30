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
    @State var typedText: String = "fklflflfl"
    @State var placeHodler = "오늘의 클라이밍은 어땠나요?"
    // @State private var isStartTyping: Bool = false
    
    @State var textStyle = UIFont.TextStyle.body
    
    private let currentDate: String = {
        let currentDate = Date()
        let formatter = DateFormatter()
        
        formatter.timeStyle = .none
        formatter.dateStyle = .medium
        formatter.locale = Locale(identifier: "ko")
        formatter.setLocalizedDateFormatFromTemplate("yyyy dd MMMM")
        return formatter.string(from: currentDate)
    }()
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading) {
                Circle()
                    .fill(.red)
                    .frame(width: 30, height: 30)
                
                Text("\(currentDate)")
                    .font(.title)
                    .padding(.bottom, 10)
                
                HStack(spacing: 5) {
                    Image(systemName: "map")
                    Text("클라임웍스 클라이밍")
                        .font(.body)
                        .foregroundColor(.gray)
                }
                .padding(.bottom, -5)
                
                HStack(spacing: 5) {
                    Image("score-star")
                        .resizable()
                        .frame(width: 20, height: 19)
                    Image("score-star")
                        .resizable()
                        .frame(width: 20, height: 19)
                    Image("score-star")
                        .resizable()
                        .frame(width: 20, height: 19)
                    Image("score-star")
                        .resizable()
                        .frame(width: 20, height: 19)
                    Image("score-star")
                        .resizable()
                        .frame(width: 20, height: 19)
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
                    
                } label: {
                    Text("수정하기")
                        .fontWeight(.bold)
                        .font(.title3)
                        .padding()
                        .background(Color("editButton"))
                        .cornerRadius(8)
                        .foregroundColor(.white)
                }
                .padding(.leading, geometry.size.width * (2/7))
            }
            .padding(.leading, 30)
            .padding(.trailing, 30)
        }
        
    }
    
}

struct MemoView_Previews: PreviewProvider {
    @State var example2 = "dd"
    
    static var previews: some View {
        MemoView()
    }
}
