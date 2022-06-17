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
        static let clientId = Bundle.main.object(forInfoDictionaryKey: "GithubClientId") as? String ?? ""
        static let secrets = Bundle.main.object(forInfoDictionaryKey: "GithubSecret") as? String ?? ""
        static let scheme = "team14-issuetracker"
    }
}
