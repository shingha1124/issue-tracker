//
//  GitHubRepositoryImpl.swift
//  issueTracker
//
//  Created by seongha shin on 2022/06/14.
//

import Foundation
import RxSwift

class GitHubRepositoryImpl: NetworkRepository<GithubTarget>, GitHubRepository {
    func requestAccessToken(code: String) -> Single<Swift.Result<Token, APIError>> {
        provider
            .request(.requestAccessToken(code: code))
            .map(Token.self)
    }
    
    func requestUser() -> Single<Swift.Result<User, APIError>> {
        provider
            .request(.requestUser)
//            .do { $0.value?.printJson() }
            .map(User.self)
    }
    
    func requestRepository() -> Single<Swift.Result<[Repository], APIError>> {
        provider
            .request(.requestRepository)
//            .do { $0.value?.printJson() }
            .map([Repository].self)
    }
    
    func requestIssueList(parameters: RequestIssueListParameters) -> Single<Swift.Result<[Issue], APIError>> {
        provider
            .request(.requestIssueList(parameters: parameters))
//            .do { $0.value?.printJson() }
            .map([Issue].self)
    }
    
    func requestUpdateIssue(parameters: RequestUpdateIssueParameters) -> Single<Swift.Result<Issue, APIError>> {
        provider
            .request(.requestUpdateIssue(parameters: parameters))
            .do { $0.value?.printJson() }
            .map(Issue.self)
    }
}
