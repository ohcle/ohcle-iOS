//
//  ScoreStar.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2023/04/02.
//

import SwiftUI

struct ScoreStar: View {
    @Binding var rating: Int
    
    private let maxRating = 5
    
    private let offImage = Image(systemName: "star.fill")
    private let onImage = Image(systemName: "star.fill")
    
    private let offColor = Color.black
    private let onColor = Color("scoreStarColor")
    
    var inform: (() -> ())?
    
    var body: some View {
        HStack{
            ForEach(1..<maxRating + 1, id:\.self) { number in
                Button {
                    rating = number
                    inform?()
                } label: {
                    Image(systemName: "star.fill")
                        .foregroundColor(number > rating ? offColor : onColor)
                }
            }
        }
    }
    
    private func image(for number: Int) -> Image {
        if number > rating {
            return offImage
        } else {
            return onImage
        }
    }
}
