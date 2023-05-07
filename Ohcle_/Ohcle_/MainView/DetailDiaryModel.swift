//
//  DetailDiaryModel.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2023/05/07.
//

import Foundation

struct ClimbingData: Codable {
    let id: Int
    let location: Location
    let when: String
    let level: Int
    let score: Double
    let memo: String
    let picture: [String]
    let video: [String]
    let tags: [String]
    let createdAt: String
    let modifiedAt: String
    let deletedAt: String?

}

struct Location: Codable {
    let id: Int
    let name: String
    let address: String
    let latitude: Double
    let longitude: Double
}

let jsonString = """
{
    "id": 1,
    "where": {
        "id": 1,
        "name": "str",
        "address": "str",
        "latitude": 37.13,
        "longitude": 127.234
    },
    "when": "2023-04-12T00:00:00Z",
    "level": 10,
    "score": 4.5,
    "memo": "some memo",
    "picture": ["pic1.jpg", "pic2.jpg"],
    "video": ["vid1.mp4", "vid2.mp4"],
    "tags": ["완등", "첫클라이밍"],
    "created_at": "2023-04-08T05:59:55.367295Z",
    "modified_at": "2023-04-08T05:59:55.367308Z",
    "deleted_at": null
}
"""

func test() {
    let jsonData = jsonString.data(using: .utf8)!
    let decoder = JSONDecoder()

    do {
        let climbingData = try decoder.decode(ClimbingData.self, from: jsonData)
        print(climbingData)
    } catch {
        print("Error decoding JSON: \(error)")
    }
}
