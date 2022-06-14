//
//  Issue.swift
//  issueTracker
//
//  Created by seongha shin on 2022/06/14.
//

import Foundation

struct Issue: Decodable {
    let number: Int
    let title: String
    let body: String?
    let state: State
    
    let labels: [Label]?
    let milestone: Milestone?
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
