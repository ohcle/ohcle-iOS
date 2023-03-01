//
//  Test.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2023/02/23.
//

import SwiftUI

struct Test: View {
    @FetchRequest(sortDescriptors: []) var diary: FetchedResults<Diary>
    @Environment(\.managedObjectContext) var moc

    var body: some View {
        Button("Add") {
            let firstNames = ["Ginny", "Harry", "Hermione", "Luna", "Ron"]
            let lastNames = ["Granger", "Lovegood", "Potter", "Weasley"]

            let chosenFirstName = firstNames.randomElement()!
            let chosenLastName = lastNames.randomElement()!
//            let student = Student(context: moc)
            let diary = Diary(context: moc)
//            diary.id = UUID()
            diary.memo = "\(chosenFirstName) \(chosenLastName)"
            try? moc.save()

            // more code to come
        }
    }
}

struct Test_Previews: PreviewProvider {
    static var previews: some View {
        Test()
    }
}
