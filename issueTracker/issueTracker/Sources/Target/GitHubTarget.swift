//
//  GitHubTarget.swift
//  issueTracker
//
//  Created by seongha shin on 2022/06/14.
//

import Foundation

enum GithubTarget {
    case requestAuth
}

extension GithubTarget: BaseTarget {
    var baseURL: URL? {
        URL(string: "")
    }
    
    var path: String? {
        switch self {
        case .requestAuth:
            return nil
        }
    }
    
    var parameter: [String: Any]? {
        switch self {
        case .requestAuth:
            return nil
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .requestAuth:
            return .get
        }
    }
    
    var content: HTTPContentType {
        switch self {
        case .requestAuth:
            return .json
        }
    }
}
