//
//  CalendarDataManager.swift
//  Ohcle_
//
//  Created by yeongbin ro on 2023/04/29.
//

import Foundation

struct Record {
    var date: String = "Record_Date"
    var level: String = "Record_Level"
    var score: Int16 = 0
    var photo: Data = Data()
    var memo: String = ""
    
    mutating func clearRecord() {
        self.date = ""
        self.score = Int16(0)
        self.level = ""
        self.photo = Data()
        self.memo = ""
    }
    
    mutating func deliverTemDiary(_ record: Record) {
        self = record
    }
    
    var temDate: String {
        get {
            self.date
        }
    }
    
    var temLevel: String {
        get {
            self.level
        }
    }
    var temScore: Int16 {
        get {
            self.score
        }
    }
    var temPhoto: Data  {
        get {
            self.photo
        }
    }
    var temMemo: String {
        get {
            self.memo
        }
    }
    
    mutating func saveTemporaryDate(_ date: String) {
        self.date = date
    }
    
    mutating func saveTemporaryLevel(_ level: String) {
        self.level = level
    }
    
    mutating func saveTemporaryScore(_ score: Int16) {
        self.score = score
    }
    
    mutating func saveTemporaryPhotoData(_ imageData: Data) {
        self.photo = imageData
    }
    
    mutating func saveTemporaryMemo(_ memo: String) {
        self.memo = memo
    }
    
    mutating func clearTemporaryPhotoData() {
        self.photo = Data()
    }
    
}

class CalendarDataManger {
    static let shared = CalendarDataManger()
//    var calenderData = CalenderData()
    var year: String = "2023"
    var month: String = "03"
    var calenderList:[CalenderModel] = []
    var record:Record = Record()
    
    
    private init() {
        
    }
    
    func getData(year: String, month: String) async {
        
        do {
            let fetchedData = try await fetchData(urlString: URLs.generateMonthRecordURLString(year: year, month: month), method: .get)
            print(fetchedData)
            let decoded = try JSONDecoder().decode([CalenderModel].self, from: fetchedData)
            print(decoded)
//            let divided = divideWeekData2(decoded)
//            self.calenderData.data = divided
            self.calenderList = decoded
            
        } catch {
            print("error")
        }
    }
    
    private func divideWeekData2(_ data: [CalenderModel]) -> [Int: [CalenderModel]] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier:
                                        "kr")
        let calendar = Calendar.current
        var dividedData: [Int: [CalenderModel]] = [:]
        
        print(data)
        data.map { data in
            let dateString = data.when
            let date = dateFormatter.date(from: dateString)
            
            let weekOfMonth = calendar.component(.weekOfMonth, from: date ?? Date())
            if (dividedData[weekOfMonth]) != nil {
                dividedData[weekOfMonth]?.append(data)
            } else {
                dividedData.updateValue([data], forKey: weekOfMonth)
            }
        }
        
        return dividedData
    }
    
    func updateDiary(diary: Diary) {
        // find specific reUcord & update in Server
    }
    
}
