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
}
