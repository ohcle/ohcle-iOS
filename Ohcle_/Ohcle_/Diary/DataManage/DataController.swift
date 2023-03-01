//
//  DataController.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2023/02/23.
//

import Foundation
import CoreData

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "TemporaryDiary")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }
    
    func saveDiary(_ context: NSManagedObjectContext) {
        let diary = Diary(context: context)
        diary.date = self.temporaryDiary.date
        diary.score = self.temporaryDiary.score
        diary.lavel = self.temporaryDiary.level
        diary.photoAddress = self.temporaryDiary.photo
        diary.memo = self.temporaryDiary.memo
    }
    
    private var temporaryDiary = TemporaryDiary()
    
    private struct TemporaryDiary {
        var date: String = OhcleDate.currentDate
        var level: String = ""
        var score: Int16 = 3
        var photo: String = "main_logo"
        var memo: String = "즐거운 클라이밍"
    }
   
    func saveTemporaryDate(_ date: String) {
        self.temporaryDiary.date = date
    }
    
    func saveTemporaryLevel(_ level: String) {
        self.temporaryDiary.level = level
    }
    
    func saveTemporaryScore(_ score: Int16) {
        self.temporaryDiary.score = score
    }
    
    func saveTemporaryPhoto(_ address: String) {
        self.temporaryDiary.photo = address
    }
    
    func saveTemporaryMemo(_ memo: String) {
        self.temporaryDiary.memo = memo
    }
}
