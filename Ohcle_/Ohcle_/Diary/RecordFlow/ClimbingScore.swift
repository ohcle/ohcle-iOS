//
//  ClimbingScore.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2022/10/22.
//

import SwiftUI

struct ClimbingScore: View {
    @State private var finalScore: Int = 3
    @EnvironmentObject var nextPage: MyPageType

    var body: some View {
        VStack(spacing: 30) {
            (Text("오늘 클라이밍의 ")
             +
             Text("점수")
                .bold())
            .font(.title)
            
            HStack {
                ScoreStar(rating: $finalScore)
                    .font(.system(size: 43))
            }
        }
        .onTapGesture {
            Debouncer(delay: 0.5).run {
                withAnimation {
                    nextPage.type = .photo
                }
            }
        }
    }
}

struct ClimbingScore_Previews: PreviewProvider {
    static var previews: some View {
        ClimbingScore()
    }
}
