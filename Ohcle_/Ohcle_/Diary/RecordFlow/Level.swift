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
    @State private var selectedColor: Color = .pink
    @State private var selectedIdx: Int = -1
    private let colors: [Color] = [.red, .orange, .yellow,
                                   Color(.systemGreen), .blue, Color.init("holder-darkblue"), .purple, .black, Color.init("holder-lightgray"), Color.init("holder-darkgray")]

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
                        self.selectedIdx = index
                        self.nextButton.userEvent.inform()
                    } label: {
                        
                        ZStack {
                            Circle()
                                .fill(colors[index].opacity(self.selectedIdx == index ? 1.0 :1.0))
                            if (self.selectedIdx == index) {
                                if (index < 8) {
                                    Image("select-color-white")
                                } else {
                                    Image("select-color-black")
                                }
                            }
                        }
                    }
                    // End of Button
                }
            }
            .padding(.leading, 20)
            .padding(.trailing, 20)

        }
        .padding(.bottom, UIScreen.screenHeight/8)
        .overlay(
            self.nextButton
                .offset(CGSize(width: 0, height: UIScreen.screenHeight/4))
        )
        .onAppear {
            if CalendarDataManger.shared.record.level !=  "" {
                let levelString = CalendarDataManger.shared.record.level
                self.selectedIdx = self.getSelectedIdx(levelString)
                self.nextButton.userEvent.inform()
            }
            
            self.nextButton.userEvent.nextButtonTouched = {
                let levelString = colors[selectedIdx].climbingLevelName
                CalendarDataManger.shared.record.saveTemporaryLevel(levelString)
            }
            
        }
        
    }
    
    func getSelectedIdx(_ selectedColor: String) -> Int {
        switch selectedColor {
        case "red" :
            return 0
        case "orange":
            return 1
        case "yellow" :
            return 2
        case "green" :
            return  3
        case "blue":
            return 4
        case "holder-darkblue"  :
            return 5
        case "purple" :
            return 6
        case "black" :
            return 7
        case "holder-lightgray" :
            return 8
        case "holder-darkgray" :
            return 9
        default:
            return -1
        }
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
        case Color.red:
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
        case .white:
            return "white"
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
            return  Color(.systemGreen)
        case "holder-darkblue"  :
            return Color("holder-darkblue")
        case "blue":
            return Color(.blue)
        case "purple" :
            return Color(.purple)
        case  "black" :
            return Color(.black)
        case  "gray" :
            return Color(.gray)
        case  "white" :
            return Color(.white)
        case "holder-lightgray" :
            return  Color("holder-lightgray")
        case "holder-darkgray" :
            return Color("holder-darkgray")
        default:
            return Color(.cyan)
        }
    }
}
