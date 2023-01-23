//
//  DiaryListCell.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2022/12/08.
//

import SwiftUI

struct DiaryListViewGridItem: View {
    @State private var gridSize: CGSize?
    
    private let placeHoldeImage = Image("main_logo")
    private let date: String
    private let location: String
    private let level: String
    private let score: String
    private let memoImageName: String?
    
    init(date: String, location: String, level: String, score: String, memoImageName: String?) {
        self.date = date
        self.location = location
        self.level = level
        self.score = score
        self.memoImageName = memoImageName
    }
    
    var body: some View {
        HStack(spacing: 10) {
            self.placeHoldeImage
                .resizable()
                .frame(width: self.gridSize?.width, height: self.gridSize?.height)
            Grid(alignment: .leading, verticalSpacing: 7) {
                GridRow {
                    Text("날짜: ")
                    Text(self.date)
                }
                GridRow {
                    Text("장소: ")
                    Text(self.location)
                }
                GridRow {
                    Text("레벨: ")
                    Text(self.level)
                }
                GridRow {
                    Text("점수: ")
                    Text(self.score)
                }
            }
            .font(.title3)
            .readSize { size in
                self.gridSize = size
            }
        }
    }
}

struct DiaryListCell_Previews: PreviewProvider {
    static var previews: some View {
        DiaryListViewGridItem(date: "ddd", location: "ddd", level: "black", score: "5", memoImageName: "main-logo")
    }
}
