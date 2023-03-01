//
//  NextButton.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2023/02/18.
//

import SwiftUI

@MainActor final class UserEvent: ObservableObject {
    @Published var isUserEventHappend: Bool = false
    
    func inform() {
            self.isUserEventHappend = true
    }
}

struct NextPageButton: View {
    let title: String
    let width: CGFloat
    let height: CGFloat
    @ObservedObject var userEvent: UserEvent = UserEvent()
    @EnvironmentObject var currentPageType: MyPageType

    private let memoButtonColor: String = "editButton"
    private let memoButtonRadius: CGFloat = 8.0

    var backgroundColor: Color {
        return userEvent.isUserEventHappend ? Color(memoButtonColor) : Color(.gray)
    }

    var body: some View {
        Button {
            changePageType()
        } label: {
            Text(title)
                .fontWeight(.bold)
                .font(.title3)
                .padding()
                .frame(width: width, height: height)
                .background(backgroundColor)
                .cornerRadius(memoButtonRadius)
                .foregroundColor(.white)
        }
    }
    
    private func changePageType() {
        switch self.currentPageType.type {
        case .calender:
            self.currentPageType.type = .location
        case .location:
            self.currentPageType.type = .level
        case .level:
            self.currentPageType.type = .score
        case .score:
            self.currentPageType.type = .photo
        case .photo:
            self.currentPageType.type = .memo
        case .memo:
            self.currentPageType.type = .done
        case .`done`:
            self.currentPageType.type = .`done`
        }
    }
}

struct NextButton_Previews: PreviewProvider {
    static var previews: some View {
        NextPageButton(title: "다음 페이지로", width: 200, height: 200)
    }
}
