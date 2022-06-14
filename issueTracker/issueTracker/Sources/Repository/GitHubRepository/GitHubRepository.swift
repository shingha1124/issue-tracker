//
//  GitHubRepository.swift
//  issueTracker
//
//  Created by seongha shin on 2022/06/14.
//

import Foundation
import RxSwift

protocol GitHubRepository {
    func requestAccessToken(code: String) -> Single<Swift.Result<Token, APIError>>
    func requestUser() -> Single<Swift.Result<User, APIError>>
    func requestRepository() -> Single<Swift.Result<[Repository], APIError>>
    func requestIssueList(parameters: RequestIssueListParameters) -> Single<Swift.Result<[Issue], APIError>>
    func requestUpdateIssue(parameters: RequestUpdateIssueParameters) -> Single<Swift.Result<Issue, APIError>>
}

struct RequestIssueListParameters {
    let owner: String
    let repo: String
    let parameters: [String: Any]?
}

struct RequestUpdateIssueParameters {
    let owner: String
    let repo: String
    let number: Int
    let parameters: [String: Any]?
}
