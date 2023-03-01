//
//  Level.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2022/10/15.
//

import SwiftUI

struct Level: View {
    @State private var commonSize: CGSize = CGSize()
    @EnvironmentObject var nextPage: MyPageType
    @State private var selectedColor: Color = .gray
    
    private let colors: [Color] = [.red, .orange, .yellow,
                                   .green, .blue, Color.init("holder-darkblue"), .purple, .black, Color.init("holder-lightgray"), Color.init("holder-darkgray")]
    
    private var columns: [GridItem] {
        [GridItem(.adaptive(minimum: 60))]
    }
    
    private var nextButton: NextPageButton =  NextPageButton(title: "다음 페이지로",
                                                             width: UIScreen.screenWidth/1.2,
                                                             height: UIScreen.screenHeight/15)
    var body: some View {
        VStack(alignment: .center) {
            (Text("무슨 ")
             + Text("레벨 ")
                .bold()
             + Text("이었나요?"))
            .font(.title)
            .padding(.bottom, 20)
            
            LazyVGrid(columns: self.columns) {
                ForEach(0..<self.colors.count) { index in
                    Button {
                        self.selectedColor = colors[index]
                    } label: {
                        Circle()
                        .fill(colors[index])
                    }
                }
            }
            .padding(.leading, 20)
            .padding(.trailing, 20)
        }
        .onDisappear {
            let levelString = self.selectedColor.description
            DataController.shared.saveTemporaryLevel(levelString)
        }
        .padding(.bottom, UIScreen.screenHeight/8)
        .overlay(
            self.nextButton
                .offset(CGSize(width: 0, height: UIScreen.screenHeight/4))
        )
    }
}

struct Level_Previews: PreviewProvider {
    static var previews: some View {
        Level()
    }
}
