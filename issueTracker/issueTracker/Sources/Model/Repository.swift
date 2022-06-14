//
//  Repository.swift
//  issueTracker
//
//  Created by seongha shin on 2022/06/14.
//

import Foundation

struct Repository: Decodable {
    let login: String?
    let name: String
    let owner: User
}
