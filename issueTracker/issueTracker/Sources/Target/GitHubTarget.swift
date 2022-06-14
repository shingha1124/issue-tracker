//
//  GitHubTarget.swift
//  issueTracker
//
//  Created by seongha shin on 2022/06/14.
//

import Foundation

enum GithubTarget {
    case requestAccessToken(code: String)
    case requestUser
    case requestRepository
    case requestIssue(owner: String, repo: String)
}

extension GithubTarget: BaseTarget {
    var baseURL: URL? {
        switch self {
        case .requestAccessToken:
            return URL(string: "https://github.com")
        default:
            return URL(string: "https://api.github.com")
        }
        
    }
    
    var path: String? {
        switch self {
        case .requestAccessToken:
            return "/login/oauth/access_token"
        case .requestUser:
            return "/user"
        case .requestRepository:
            return "/user/repos"
        case .requestIssue(let owner, let repo):
            return "/repos/\(owner)/\(repo)/issues"
        }
    }
    
    var parameter: [String: Any]? {
        switch self {
        case .requestAccessToken(let code):
            return ["client_id": Constants.Login.gitHubClientId, "client_secret": Constants.Login.gitHubSecrets, "code": code ]
        default:
            return nil
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .requestAccessToken:
            return .post
        case .requestUser, .requestRepository, .requestIssue:
            return .get
        }
    }
    
    var content: HTTPContentType {
        switch self {
        case .requestAccessToken, .requestUser, .requestRepository, .requestIssue:
            return .json
        }
    }
}
