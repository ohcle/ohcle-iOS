//
//  NextButton.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2023/02/18.
//

import SwiftUI

@MainActor final class UserEvent: ObservableObject {
    @Published var isUserEventHappend: Bool = false
    var nextButtonTouched: (() -> Void)?
    
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
    
    var date: String?
    var level: String?
    var score: Int16?
    var photo: Data?
    var memo: String?
    var climbingLocation: ClimbingLocation?
    

    private let memoButtonColor: String = "editButton"
    private let memoButtonRadius: CGFloat = 8.0
    

    var backgroundColor: Color {
        return userEvent.isUserEventHappend ? Color(memoButtonColor) : Color(.gray)
    }

    var body: some View {
        VStack {
            Button {
                if userEvent.isUserEventHappend {
                    saveTempdata()
                    changePageType()
                    userEvent.nextButtonTouched?()
                }
                
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
    }
    
    func activateNextButton() {
        self.userEvent.isUserEventHappend = true
    }
    
    func deactivateNextButton() {
        self.userEvent.isUserEventHappend = false
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
            self.currentPageType.type = .calender
        }
    }
    
    private func saveTempdata() {
        switch self.currentPageType.type {
        case .calender:
            if let date = self.date {
                CalendarDataManger.shared.record.saveTemporaryDate(date)
            }
        case .location:
            if let climbingLocation = self.climbingLocation {
                CalendarDataManger.shared.record.saveTemporaryLocation(climbingLocation)
            }
        case .score:
            if let score = self.score {
                CalendarDataManger.shared.record.saveTemporaryScore(score)
            }
        case .photo:
            if let photo = self.photo {
                CalendarDataManger.shared.record.saveTemporaryPhotoData(photo)
            }
        case .level:
            if let level = self.level {
                CalendarDataManger.shared.record.saveTemporaryLevel(level)
            }
        case .memo:
            if let memo = self.memo {
                CalendarDataManger.shared.record.saveTemporaryMemo(memo)
            }
        case .`done`:
            break
        }
    }
}

struct NextButton_Previews: PreviewProvider {
    static var previews: some View {
        NextPageButton(title: "다음", width: 200, height: 200)
    }
}
