//
//  Comment.swift
//  issueTracker
//
//  Created by 이준우 on 2022/06/30.
//

import Foundation

struct Comment: Codable {
    
    let id: Int
    let body: String
    let createdAt: Date
    let updatedAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id, body
        case updatedAt = "updated_at"
        case createdAt = "created_at"
    }
}
