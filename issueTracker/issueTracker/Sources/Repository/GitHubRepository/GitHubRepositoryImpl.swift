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
    
    func requestRepoIssueList(parameters: RequestIssueListParameters) -> Single<Swift.Result<[Issue], APIError>> {
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
    
    func requestLabels(parameters: RequestLabelsParameters) -> Single<Swift.Result<[Label], APIError>> {
        provider
            .request(.requestLabels(parameters: parameters))
            .map([Label].self)
    }
    
    func requestAssignees(parameters: RequestAssigneesParameters) -> Single<Swift.Result<[User], APIError>> {
        provider
            .request(.requestAssignees(parameters: parameters))
            .map([User].self)
    }
    
    func requestCreatingLabel(parameters: RequestCreatingLabelParameters) -> Single<Swift.Result<[Label], APIError>> {
        provider
            .request(.requestCreatingLabel(parameters: parameters))
            .do { $0.value?.printJson() }
            .map([Label].self)
    }
    
    func requestMilestones(parameters: RequestMilestoneParameters) -> Single<Result<[Milestone], APIError>> {
        provider
            .request(.requestMilestones(parameters: parameters))
            .do { $0.value?.printJson() }
            .map([Milestone].self)
    }
    
    func requestCreatingMilestone(parameters: RequestCreatingMilestoneParameters) -> Single<Result<[Milestone], APIError>> {
        provider
            .request(.requestCreatingMilestone(parameters: parameters))
            .do { $0.value?.printJson() }
            .map([Milestone].self)
    }
}
