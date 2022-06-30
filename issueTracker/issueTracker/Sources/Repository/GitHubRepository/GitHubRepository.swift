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
    
    func requestRepositories() -> Single<Swift.Result<[Repository], APIError>>
    func requestRepository(parameters: RequestRepositoryParameters) -> Single<Swift.Result<Repository, APIError>>
    
    func requestRepoIssueList(parameters: RequestRepositoryParameters) -> Single<Swift.Result<[Issue], APIError>>
    func requestUpdateIssue(parameters: RequestUpdateIssueParameters) -> Single<Swift.Result<Issue, APIError>>
    
    func requestLabels(parameters: RequestRepositoryParameters) -> Single<Swift.Result<[Label], APIError>>
    func requestAssignees(parameters: RequestRepositoryParameters) -> Single<Swift.Result<[User], APIError>>
    
    func requestCreatingLabel(parameters: RequestRepositoryParameters) -> Single<Swift.Result<[Label], APIError>>
    
    func requestMilestones(parameters: RequestRepositoryParameters) -> Single<Swift.Result<[Milestone], APIError>>
    
    func requestCreatingMilestone(parameters: RequestRepositoryParameters) -> Single<Swift.Result<[Milestone], APIError>>
    
    func requestCreateIssue(parameters: RequestRepositoryParameters) -> Single<Swift.Result<Issue, APIError>>
    
    func requestIssueComments(parameters: RequestUpdateIssueParameters) -> Single<Swift.Result<[Comment], APIError>>
    func requestAvatarImage(url: URL) -> Single<Swift.Result<Data, APIError>>
    
    func requestCreatingComment(parameters: RequestUpdateIssueParameters) -> Single<Swift.Result<Comment, APIError>>
}

struct RequestRepositoryParameters {
    let owner = Constants.Github.repositoryOwner
    let repo = Constants.Github.repositoryName
    let parameters: [String: Any]?
}

struct RequestUpdateIssueParameters {
    let owner = Constants.Github.repositoryOwner
    let repo = Constants.Github.repositoryName
    let number: Int
    let parameters: [String: Any]?
}
