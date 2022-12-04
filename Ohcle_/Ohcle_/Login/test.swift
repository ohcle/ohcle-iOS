//
//  test.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2022/12/04.
//

import SwiftUI
var testData: [Data] = []

class MyModelObject: ObservableObject {
    @Published var path: NavigationPath

        static func readSerializedData() -> Data? {
            // Read data representing the path from app's persistent storage.
            return testData.last
         }

        static func writeSerializedData(_ data: Data) {
            // Write data representing the path to app's persistent storage.
            testData.append(data)
        }

        init() {
            if let data = Self.readSerializedData() {
                do {
                    let representation = try JSONDecoder().decode(
                        NavigationPath.CodableRepresentation.self,
                        from: data)
                    self.path = NavigationPath(representation)
                } catch {
                    self.path = NavigationPath()
                }
            } else {
                self.path = NavigationPath()
            }
        }

        func save() {
            guard let representation = path.codable else { return }
            do {
                let encoder = JSONEncoder()
                let data = try encoder.encode(representation)
                Self.writeSerializedData(data)
            } catch {
                print(error)
            }
        }
}
