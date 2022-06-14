//
//  Issue.swift
//  issueTracker
//
//  Created by seongha shin on 2022/06/14.
//

import Foundation

struct Issue: Decodable {
    let title: String
    let body: String?
    
    let labels: [Label]?
    let milestone: Milestone?
}
