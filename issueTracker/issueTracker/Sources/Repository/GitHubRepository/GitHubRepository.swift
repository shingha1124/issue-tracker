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
    func requestIssue(owner: String, repo: String) -> Single<Swift.Result<[Issue], APIError>>
}
