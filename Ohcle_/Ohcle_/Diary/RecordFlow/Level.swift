//
//  Level.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2022/10/15.
//

import SwiftUI

struct LevelCircle: View {
    let colors: [Color]
    var body: some View {
        GeometryReader { geometry in
            HStack() {
                Spacer()
                ForEach(0..<self.colors.count) {
                    Circle()
                        .fill(colors[$0])
                        .frame(width: geometry.size.width / 6.5)
                }
                Spacer()
            }
        }
    }
}

struct Level: View {
    @State private var commonSize: CGSize = CGSize()
    private let firstLowcolors: [Color] = [.red, .orange, .yellow, .green, .blue]
    private let secondLowColors: [Color] = [Color.init("holder-darkblue"), .purple, .black, Color.init("holder-lightgray"), Color.init("holder-darkgray")]
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center) {
                
                (Text("무슨 ")
                 + Text("레벨 ")
                    .bold()
                + Text("이었나요?"))
                .font(.title)
                
                LevelCircle(colors: self.firstLowcolors)
                LevelCircle(colors: self.secondLowColors)
            }
            .frame(width: geometry.size.width,
                   height: geometry.size.height/4)
            .padding(.top, geometry.size.height / 3)
        }
    }
}

struct Level_Previews: PreviewProvider {
    static var previews: some View {
        Level()
    }
}
