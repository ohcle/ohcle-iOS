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
    @EnvironmentObject var nextPage: MyPageType
    
    private let firstLowcolors: [Color] = [.red, .orange, .yellow, .green, .blue]
    private let secondLowColors: [Color] = [Color.init("holder-darkblue"), .purple, .black, Color.init("holder-lightgray"), Color.init("holder-darkgray")]
    
    private var nextButton: NextPageButton =  NextPageButton(title: "다음 페이지로",
                                                             width: UIScreen.screenWidth/1.2,
                                                             height: UIScreen.screenHeight/15)
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center) {
                
                (Text("무슨 ")
                 + Text("레벨 ")
                    .bold()
                + Text("이었나요?"))
                .font(.title)
                
                LevelCircle(colors: self.firstLowcolors)
                    .onTapGesture {
                        self.nextButton.userEvent.inform()
                    }
                
                LevelCircle(colors: self.secondLowColors)
                    .onTapGesture {
                        self.nextButton.userEvent.inform()

                    }
            }
            .overlay(
                self.nextButton
                    .offset(CGSize(width: 0, height: UIScreen.screenHeight/4))
            )
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
