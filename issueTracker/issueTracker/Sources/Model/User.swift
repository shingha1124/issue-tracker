//
//  User.swift
//  issueTracker
//
//  Created by seongha shin on 2022/06/14.
//

import Foundation

struct User: Decodable {
    let id: Int
    let login: String
    let name: String?
    let email: String?
}
