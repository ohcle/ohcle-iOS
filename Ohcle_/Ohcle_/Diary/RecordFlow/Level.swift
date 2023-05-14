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
    
    private var nextButton: NextPageButton =  NextPageButton(title: "다음",
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
                        self.nextButton.userEvent.inform()
                    } label: {
                        
                        ZStack {
                            Circle()
                                .fill(colors[index].opacity(self.selectedColor == colors[index] ? 1.0 : 0.7))
                            Circle()
                                .strokeBorder(self.selectedColor == colors[index] ? .black : .clear, lineWidth: 5)
//                            Circle()
//                                .fill(self.selectedColor == colors[index] ? .clear : .black.opacity(0.25))
                        }
                    }
                }
            }
            .padding(.leading, 20)
            .padding(.trailing, 20)
        }
        .onDisappear {
            let levelString = self.selectedColor.climbingLevelName
            CalendarDataManger.shared.record.saveTemporaryLevel(levelString)
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

extension Color {
    var climbingLevelName: String {
        switch self {
        case .red:
            return "red"
        case .orange:
            return "orange"
        case .yellow:
            return "yellow"
        case .green:
            return "green"
        case .blue:
            return "blue"
        case Color("holder-darkblue"):
            return "holder-darkblue"
        case .purple:
            return "purple"
        case .black:
            return "black"
        case .indigo:
            return "indigo"
        case Color("holder-lightgray"):
            return "holder-lightgray"
        case Color("holder-darkgray"):
            return "holder-darkgray"
        default:
            return "Level Color Error"
        }
    }
    
   static func convert(from climbingLevelName: String) -> Color {
        switch climbingLevelName {
        case "red" :
            return Color(.red)
        case "orange":
            return Color(.orange)
        case "yellow" :
            return Color(.yellow)
        case "green" :
            return  Color(.green)
        case "holder-darkblue"  :
            return Color("holder-darkblue")
        case "blue":
            return Color(.blue)
        case "purple" :
            return Color(.purple)
        case  "black" :
            return Color(.black)
        case  "indigo" :
            return Color(.systemIndigo)
        case "holder-lightgray" :
            return  Color("holder-lightgray")
        case "holder-darkgray" :
            return Color("holder-darkgray")
        default:
            return Color(.cyan)
        }
    }
}
