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
    
    case requestRepositorys
    case requestRepository(parameters: RequestRepositoryParameters)
    
    case requestAllIssueList
    case requestRepoIssueList(parameters: RequestIssueListParameters)
    case requestUpdateIssue(parameters: RequestUpdateIssueParameters)
    
    case requestLabels(parameters: RequestLabelsParameters)
    
    case requestAssignees(parameters: RequestAssigneesParameters)
    case requestCreatingLabel(parameters: RequestCreatingLabel)
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
        case .requestRepositorys:
            return "/user/repos"
        case .requestRepository(let param):
            return "/repos/\(param.owner)/\(param.repo)"
        case .requestAllIssueList:
            return "/issues"
        case .requestRepoIssueList(let param):
            return "/repos/\(param.owner)/\(param.repo)/issues"
        case .requestUpdateIssue(let param):
            return "/repos/\(param.owner)/\(param.repo)/issues/\(param.number)"
        case .requestLabels(let param):
            return "/repos/\(param.owner)/\(param.repo)/labels"
        case .requestAssignees(let param):
            return "/repos/\(param.owner)/\(param.repo)/assignees"
        case .requestCreatingLabel(parameters: let param):
            return "/repos/\(param.owner)/\(param.repo)/labels"
        }
    }
    
    var parameter: [String: Any]? {
        switch self {
        case .requestAccessToken(let code):
            return ["client_id": Constants.Github.clientId, "client_secret": Constants.Github.secrets, "code": code, "scope": "repo,user" ]
        case .requestRepoIssueList(let param):
            return param.parameters
        case .requestUpdateIssue(let param):
            return param.parameters
        case .requestCreatingLabel(let param) :
            return param.parameters
        default:
            return nil
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .requestAccessToken:
            return .post
        case .requestUpdateIssue:
            return .patch
        case .requestCreatingLabel(parameters: _):
            return .post
        default:
            return .get
        }
    }
    
    var content: HTTPContentType {
        switch self {
        default:
            return .json
        }
    }
}
