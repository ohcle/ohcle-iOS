//
//  DiarySaver.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2023/02/20.
//

import SwiftUI

final class DiaryManager {
    private init() { }
    
    static let shared = DiaryManager()
    private let temporaryDiary: TemporaryDiary = TemporaryDiary()
    
    private class TemporaryDiary {
        var date: String = OhcleDate.currentDate
        var level: Color = .blue
        var score: Int = 3
        var photo: Image = Image("main_logo")
        var memo: String = "즐거운 클라이밍"
    }
    
    var temporaryDate: String {
        return self.temporaryDiary.date
    }
    
    var temporaryLevel: Color {
        return self.temporaryDiary.level
    }
    
    var temporaryScore: Int {
        return self.temporaryDiary.score
    }
    
    var temporaryPhoto: Image {
        return self.temporaryDiary.photo
    }
    
    var temporaryMemo: String {
        return self.temporaryDiary.memo
    }
   
    func saveDate(_ date: String) {
        self.temporaryDiary.date = date
    }
    
    func saveLevel(_ level: Color) {
        self.temporaryDiary.level = level
    }
    
    func saveScore(_ score: Int) {
        self.temporaryDiary.score = score
    }
    
    func savePhoto(_ photo: Image) {
        self.temporaryDiary.photo = photo
    }
    
    func save(_ memo: String) {
        self.temporaryDiary.memo = memo
    }
}
