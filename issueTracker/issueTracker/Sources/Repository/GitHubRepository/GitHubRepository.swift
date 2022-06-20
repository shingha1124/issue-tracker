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
    
    func requestRepoIssueList(parameters: RequestIssueListParameters) -> Single<Swift.Result<[Issue], APIError>>
    func requestUpdateIssue(parameters: RequestUpdateIssueParameters) -> Single<Swift.Result<Issue, APIError>>
    
    func requestLabels(parameters: RequestLabelsParameters) -> Single<Swift.Result<[Label], APIError>>
    func requestAssignees(parameters: RequestAssigneesParameters) -> Single<Swift.Result<[User], APIError>>
    
    func requestCreatingLabel(parameters: RequestCreatingLabelParameters) -> Single<Swift.Result<[Label], APIError>>
    
    func requestMilestones(parameters: RequestMilestoneParameters) -> Single<Swift.Result<[Milestone], APIError>>
}

struct RequestAssigneesParameters {
    let owner: String
    let repo: String
}

struct RequestLabelsParameters {
    let owner: String
    let repo: String
}

struct RequestRepositoryParameters {
    let owner: String
    let repo: String
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

struct RequestCreatingLabelParameters {
    let owner: String
    let repo: String
    let parameters: [String: Any]?
}

struct RequestMilestoneParameters {
    let owner: String
    let repo: String
}
