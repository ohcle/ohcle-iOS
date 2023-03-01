//
//  DataController.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2023/02/23.
//

import Foundation
import CoreData
import SwiftUI

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "TemporaryDiary")
    static let shared = DataController()
    
    private init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }
    
    private func saveContext() {
        let context = self.container.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let saveError = error as NSError
                print("Context Saving Error: \(saveError.localizedDescription)")
            }
        }
    }
    
    func saveDiary(_ context: NSManagedObjectContext) {
        let diary = Diary(context: context)
        diary.date = self.temporaryDiary.date
        diary.score = self.temporaryDiary.score
        diary.lavel = self.temporaryDiary.level
        diary.photo = self.temporaryDiary.photo
        diary.memo = self.temporaryDiary.memo
        
        self.saveContext()
    }
    
//    func updateDiary(_ context: NSManagedObjectContext) {
//        self.saveDiary(context)
//        self.saveContext()
//    }
//
//    func deleteDiary() {
//        self.saveContext()
//    }
//
//    func readDiary() -> Diary {
//
//    }
    
    private var temporaryDiary = TemporaryDiary()
    
    private struct TemporaryDiary {
        var date: String = "💜"
        var level: String = "💜"
        var score: Int16 = 0
        var photo: Data = Data()
        var memo: String = "💜"
    }
   
    var temDate: String {
        get {
            self.temporaryDiary.date
        }
    }
    
    var temLevel: String {
        get {
            self.temporaryDiary.level
        }
    }
    var temScore: Int16 {
        get {
            self.temporaryDiary.score
        }
    }
    var temPhoto: Data  {
        get {
            self.temporaryDiary.photo
        }
    }
    var temMemo: String {
        get {
            self.temporaryDiary.memo
        }
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
    
    func saveTemporaryPhotoData(_ imageData: Data) {
        self.temporaryDiary.photo = imageData
    }
    
    func saveTemporaryMemo(_ memo: String) {
        self.temporaryDiary.memo = memo
    }
}
