//
//  Token.swift
//  issueTracker
//
//  Created by seongha shin on 2022/06/14.
//

import Foundation

struct Token: Codable {
    let accessToken: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "jwt"
    }
}
