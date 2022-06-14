//
//  GitHubTarget.swift
//  issueTracker
//
//  Created by seongha shin on 2022/06/14.
//

import Foundation

enum GithubTarget {
    case requestAccessToken(code: String)
}

extension GithubTarget: BaseTarget {
    var baseURL: URL? {
        URL(string: "https://github.com")
    }
    
    var path: String? {
        switch self {
        case .requestAccessToken:
            return "/login/oauth/access_token"
        }
    }
    
    var parameter: [String: Any]? {
        switch self {
        case .requestAccessToken(let code):
            return ["client_id": Constants.Login.gitHubClientId, "client_secret": Constants.Login.gitHubSecrets, "code": code ]
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .requestAccessToken:
            return .post
        }
    }
    
    var content: HTTPContentType {
        switch self {
        case .requestAccessToken:
            return .json
        }
    }
}
