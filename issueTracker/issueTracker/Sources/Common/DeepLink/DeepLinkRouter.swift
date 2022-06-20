//
//  DeepLinkRouter.swift
//  issueTracker
//
//  Created by seongha shin on 2022/06/14.
//

import Foundation
import RxRelay
import RxSwift

final class DeepLinkRouter {
    
    private let registDeepLink = PublishRelay<URL>()
    private let disposeBag = DisposeBag()
    
    @Inject(\.gitHubRepository) private var gitHubRepository: GitHubRepository
    @Inject(\.tokenStore) private var tokenStore: TokenStore
    
    weak var appCoordinator: AppCoordinator?
    
    init(appCoordinator: AppCoordinator?) {
        self.appCoordinator = appCoordinator
        
        let requestGitHubAccessToken = registDeepLink
            .filter { $0.host == "github" }
            .compactMap { URLComponents(string: $0.absoluteString) }
            .compactMap { $0.queryItems?.filter { $0.name == "code" }.first?.value }
            .withUnretained(self)
            .flatMapLatest { router, code in
                router.gitHubRepository.requestAccessToken(code: code)
            }
            .share()
        
        requestGitHubAccessToken
            .compactMap { $0.value }
            .withUnretained(self)
            .do { router, token in
                router.tokenStore.store(token)
            }
            .bind(onNext: { router, _ in
                router.appCoordinator?.switchRootViewController(.home)
            })
            .disposed(by: disposeBag)
    }
}

extension DeepLinkRouter {
    func handle(_ url: URL) {
        registDeepLink.accept(url)
    }
}

struct DeepLink {
    let host: String?
    let query: String?
}
