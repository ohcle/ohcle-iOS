//
//  DiaryListCell.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2022/12/08.
//

import SwiftUI

extension UIScreen {
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let screenSize = UIScreen.main.bounds.size
}

//DiaryListViewGridItem(date: diary.date, location: "더미 로케이션", level: diary.lavel, score: diary.score, memoImageName: diary.photo)

struct DiaryListViewGridItem: View {
    private let placeHoldeImage = Image("main_logo")
    
    @State private var scoreNumber = 3
    
    private let date: String?
    private let location: String?
    private let levelColor: Color
    private let memoImageData: Data?
    
    init(date: String?, location: String?,
         levelColorName: String, score: Int16?, memoImageData: Data?) {
        self.date = date
        self.location = location
        self.levelColor = Color.convert(from: levelColorName)
        self.scoreNumber = Int(score ?? .zero)
        self.memoImageData = memoImageData
    }
    
    
    private func generateMemoImage() -> Image {
        if let data = self.memoImageData {
            return Image(uiImage: UIImage(data: data) ?? UIImage())
        } else {
           return self.placeHoldeImage
        }
    }
    
    let rows = [GridItem(.fixed(20)), GridItem(.fixed(80))]
    var body: some View {
        HStack(spacing: 10) {
            self.generateMemoImage()
                .resizable()
                .frame(width: UIScreen.screenSize.width * 2/7, height: UIScreen.screenSize.width * 2/7)
            LazyVStack(alignment: .leading, spacing: 13) {
                Text("날짜  ")
                    .foregroundColor(.gray)
                + Text(self.date ?? OhcleDate.currentDate)
                
                Text("장소  ")
                    .foregroundColor(.gray)
                +
                Text(self.location ?? "오클 클라이밍")
                
                HStack {
                    Text("레벨 ")
                        .foregroundColor(.gray)
                    Circle()
                        .foregroundColor(self.levelColor)
                        .frame(width: 18)
                }
                
                HStack {
                    Text("점수")
                        .foregroundColor(.gray)
                    ScoreStar(rating: $scoreNumber)
                        .allowsHitTesting(false)
                        .padding(.bottom, 3)
                }
            }
        }
    }
}

struct DiaryListCell_Previews: PreviewProvider {
    static private let mocDate = "2023년 3월 10일"
    static private let mocLocation = "오클 클라이밍"
    static private let mocColorName = "gray"
    static private let mocScore: Int16 = 3
    static private let mocImageData = Data()
    
    static var previews: some View {
        DiaryListViewGridItem(date: mocDate, location: mocLocation, levelColorName: mocColorName, score: mocScore, memoImageData: mocImageData)
    }
}
