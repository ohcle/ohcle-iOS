//
//  ClimbingScore.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2022/10/22.
//

import SwiftUI

struct ClimbingScore: View {
    private let scoreLange = (0...4)
    @EnvironmentObject var nextPage: MyPageType

    var body: some View {
        VStack {
            (Text("오늘 클라이밍의 ")
             +
             Text("점수")
                .bold())
            .font(.title)
            
            HStack {
                ScoreStar()
                ScoreStar()
                ScoreStar()
                ScoreStar()
                ScoreStar()
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
