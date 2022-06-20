//
//  Environment.swift
//  airbnb
//
//  Created by seongha shin on 2022/06/07.
//

import Foundation

enum Constants {
    enum Github {
        static let authorizeUrl = "https://github.com/login/oauth/authorize"
        static let authorizeQuery = ["client_id": clientId, "scope": "repo,user" ]
        static let clientId = "c2dd7cd1d58bca22141d"
        static let secrets = "7be4a8fbbefb10fe96f62bd8ffa1e6e3ec525aca"
        static let scheme = "team14-issuetracker"
    }
}
