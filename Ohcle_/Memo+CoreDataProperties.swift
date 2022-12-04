//
//  Memo+CoreDataProperties.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2022/12/04.
//
//

import Foundation
import CoreData


extension Memo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Memo> {
        return NSFetchRequest<Memo>(entityName: "Memo")
    }

    @NSManaged public var date: String?
    @NSManaged public var review: String?
    @NSManaged public var address: String?
    @NSManaged public var level: String?
    @NSManaged public var grade: Double

}

extension Memo : Identifiable {

}
