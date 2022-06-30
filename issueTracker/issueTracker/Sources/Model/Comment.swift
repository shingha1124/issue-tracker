//
//  Comment.swift
//  issueTracker
//
//  Created by 이준우 on 2022/06/30.
//

import Foundation

struct Comment: Decodable {
    
    let id: Int
    let body: String
    let createdAt: Date
    let updatedAt: Date
    let user: User
    
    enum CodingKeys: String, CodingKey {
        case id, body, user
        case updatedAt = "updated_at"
        case createdAt = "created_at"
    }
}
