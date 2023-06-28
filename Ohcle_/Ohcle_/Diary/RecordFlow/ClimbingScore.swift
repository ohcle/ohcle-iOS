//
//  ClimbingScore.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2022/10/22.
//

import SwiftUI

struct ClimbingScore: View {
    @State private var finalScore: Int = 0
    @EnvironmentObject var nextPage: MyPageType
    private var nextButton: NextPageButton =  NextPageButton(title: "다음",
                                                             width: UIScreen.screenWidth/1.2,
                                                             height: UIScreen.screenHeight/15)
    
    var body: some View {
        VStack(spacing: 30) {
            (Text("오늘 클라이밍의 ")
             +
             Text("점수")
                .bold())
            .font(.title)
            
            HStack {
                ScoreStar(rating: $finalScore,
                          inform: self.nextButton.userEvent.inform)
                    .font(.system(size: 43))
            }

        }
        .padding(.bottom, UIScreen.screenHeight/8)
        .overlay(
            self.nextButton
                .offset(CGSize(width: 0, height: UIScreen.screenHeight/4))
        )
        .onAppear {
            if CalendarDataManger.shared.record.score != 0 {
                finalScore = Int(CalendarDataManger.shared.record.score)
                self.nextButton.userEvent.inform()
            }
            
            self.nextButton.userEvent.nextButtonTouched = {
                CalendarDataManger.shared.record.saveTemporaryScore(Int16(self.finalScore))
            }
        }
    }
}

struct ClimbingScore_Previews: PreviewProvider {
    static var previews: some View {
        ClimbingScore()
    }
}
