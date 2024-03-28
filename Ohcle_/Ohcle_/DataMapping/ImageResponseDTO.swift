//
//  ImageResponseDTO.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 3/28/24.
//

import Foundation

// MARK: - Image in Climbing Record Data Transfer Object

struct ClimbingImageResponseDTO: Decodable {
    let image: String
}

struct ConvertedClimbingImageModelDTO: Decodable {
    let filename: String
}

// MARK: - Mappings to Domain (실제페이지와 연결)

