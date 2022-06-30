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
            .map(User.self)
    }
    
    func requestRepositories() -> Single<Swift.Result<[Repository], APIError>> {
        provider
            .request(.requestRepositorys)
            .map([Repository].self)
    }
    
    func requestRepository(parameters: RequestRepositoryParameters) -> Single<Swift.Result<Repository, APIError>> {
        provider
            .request(.requestRepository(parameters: parameters))
            .map(Repository.self)
    }
    
    func requestRepoIssueList(parameters: RequestRepositoryParameters) -> Single<Swift.Result<[Issue], APIError>> {
        provider
            .request(.requestRepoIssueList(parameters: parameters))
            .do { $0.value?.printJson() }
            .map([Issue].self)
    }
    
    func requestUpdateIssue(parameters: RequestUpdateIssueParameters) -> Single<Swift.Result<Issue, APIError>> {
        provider
            .request(.requestUpdateIssue(parameters: parameters))
            .do { $0.value?.printJson() }
            .map(Issue.self)
    }
    
    func requestLabels(parameters: RequestRepositoryParameters) -> Single<Swift.Result<[Label], APIError>> {
        provider
            .request(.requestLabels(parameters: parameters))
            .map([Label].self)
    }
    
    func requestAssignees(parameters: RequestRepositoryParameters) -> Single<Swift.Result<[User], APIError>> {
        provider
            .request(.requestAssignees(parameters: parameters))
            .map([User].self)
    }
    
    func requestCreatingLabel(parameters: RequestRepositoryParameters) -> Single<Swift.Result<[Label], APIError>> {
        provider
            .request(.requestCreatingLabel(parameters: parameters))
            .do { $0.value?.printJson() }
            .map([Label].self)
    }
    
    func requestMilestones(parameters: RequestRepositoryParameters) -> Single<Result<[Milestone], APIError>> {
        provider
            .request(.requestMilestones(parameters: parameters))
            .do { $0.value?.printJson() }
            .map([Milestone].self)
    }
    
    func requestCreatingMilestone(parameters: RequestRepositoryParameters) -> Single<Result<[Milestone], APIError>> {
        provider
            .request(.requestCreatingMilestone(parameters: parameters))
            .do { $0.value?.printJson() }
            .map([Milestone].self)
    }
    
    func requestCreateIssue(parameters: RequestRepositoryParameters) -> Single<Result<Issue, APIError>> {
        provider
            .request(.requestCreateIssue(parameters: parameters))
            .do { $0.value?.printJson() }
            .map(Issue.self)
    }
    
    func requestIssueComments(parameters: RequestUpdateIssueParameters) -> Single<Result<[Comment], APIError>> {
        provider
            .request(.requestIssueComments(parameters: parameters))
            .do { $0.value?.printJson() }
            .map([Comment].self)
    }
    
    func requestAvatarImage(url: URL) -> Single<Result<Data, APIError>> {
        provider
            .request(.requestAvatarImage(url: url))
            .map(Data.self)
    }
}
