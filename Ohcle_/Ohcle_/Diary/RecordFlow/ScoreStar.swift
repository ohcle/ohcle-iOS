//
//  ScoreStar.swift
//  Ohcle_
//
//  Created by yeongbin ro on 2023/03/26.
//


//ScoreStar(rating: $finalScore,
//          inform: self.nextButton.userEvent.inform)
//    .font(.system(size: 43))
//ScoreStar(rating: .constant(Int(score)))
import SwiftUI

struct ScoreStar: View {
    @Binding var rating: Int
    var inform: @MainActor () -> () =  {}
    
    
    var body: some View {
        Star(inform: inform)
            .onTapGesture {
                inform()
            }
    }
}


struct Star: View {
    @State private var currentRating: Int = 0
    var inform: @MainActor () -> () =  {}
    
    var body: some View {
        HStack {
            ForEach(0..<5) { index in
                if index < currentRating {
                    Image("score-star")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } else {
                    Image("score-emptystar")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
            }
        }
        .onTapGesture {
            currentRating += 1
            inform()
        }
    }
    
}
