//
//  Milestone.swift
//  issueTracker
//
//  Created by seongha shin on 2022/06/14.
//

import Foundation

struct Milestone: Codable {
    let title: String
    let description: String
    let deadline: Date?
    let openedIssueCount: Int
    let closedIssueCount: Int
    
    enum CodingKeys: String, CodingKey {
        case title, description
        case deadline = "due_on"
        case openedIssueCount = "open_issues"
        case closedIssueCount = "closed_issues"
    }
}
