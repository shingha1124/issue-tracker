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
    case requestIssueList(parameters: RequestIssueListParameters)
    case requestUpdateIssue(parameters: RequestUpdateIssueParameters)
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
        case .requestIssueList(let param):
            return "/repos/\(param.owner)/\(param.repo)/issues"
        case .requestUpdateIssue(let param):
            return "/repos/\(param.owner)/\(param.repo)/issues/\(param.number)"
        }
    }
    
    var parameter: [String: Any]? {
        switch self {
        case .requestAccessToken(let code):
            return ["client_id": Constants.Login.gitHubClientId, "client_secret": Constants.Login.gitHubSecrets, "code": code, "scope": "repo,user" ]
            
//            URLQueryItem(name: "scope", value: "repo,user")
        case .requestIssueList(let param):
            return param.parameters
        case .requestUpdateIssue(let param):
            return param.parameters
        default:
            return nil
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .requestAccessToken:
            return .post
        case .requestUser, .requestRepository, .requestIssueList:
            return .get
        case .requestUpdateIssue:
            return .patch
        }
    }
    
    var content: HTTPContentType {
        switch self {
        default:
            return .json
        }
    }
}
