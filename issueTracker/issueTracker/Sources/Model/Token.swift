//
//  Token.swift
//  issueTracker
//
//  Created by seongha shin on 2022/06/14.
//

import Foundation

struct Token: Codable {
    let accessToken: String
    let refreshToken: String?
    let scope: String
    
    enum CodingKeys: String, CodingKey {
        case scope
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
    }
}
