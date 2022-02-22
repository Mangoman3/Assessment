//
//  Models.swift
//  Assessment
//
//  Created by Arsalan Ghaffar on 2/21/22.
//

import Foundation

// MARK: - Exercise
struct ExerciseResult: Codable, Hashable {
    let count: Int?
    let next: String?
    let results: [Exercise]?
    
}

// MARK: - Exercise
struct Exercise: Codable, Hashable {
    let idHash = UUID()
    let id: Int?
    let name, uuid, description : String?
    let images: [ImageData]?
    let variations: [Int]?
    
    enum CodingKeys: String, CodingKey {
        case id, name, uuid
        case images, variations, description
    }
    static func == (lhs: Exercise, rhs: Exercise) -> Bool {
        lhs.idHash == rhs.idHash
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(idHash)
    }
}
// MARK: - Image
struct ImageData: Codable, Hashable {
    let idHash = UUID()
    let id: Int
    let uuid: String
    let exerciseBase: Int
    let image: String
    let isMain: Bool
    let status: String
    
    enum CodingKeys: String, CodingKey {
        case id, uuid
        case exerciseBase = "exercise_base"
        case image
        case isMain = "is_main"
        case status
    }
    
    static func == (lhs: ImageData, rhs: ImageData) -> Bool {
        lhs.idHash == rhs.idHash
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(idHash)
    }
}
