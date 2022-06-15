//
//  Issue.swift
//  issueTracker
//
//  Created by seongha shin on 2022/06/14.
//

import Foundation

protocol BaseCoreData {
    var id: Int { get }
    var updatedAt: Date { get }
}

struct Issue: Decodable, BaseCoreData {
    let id: Int
    let number: Int
    let title: String
    let body: String?
    var state: State
    let updatedAt: Date
    
    let labels: [Label]?
    let milestone: Milestone?
    
    enum CodingKeys: String, CodingKey {
        case id, number, title, body, state, labels, milestone
        case updatedAt = "updated_at"
    }
}

extension Issue {
    enum State: String, Decodable {
        case open
        case closed
        case all
        
        var value: String {
            self.rawValue
        }
    }
}
