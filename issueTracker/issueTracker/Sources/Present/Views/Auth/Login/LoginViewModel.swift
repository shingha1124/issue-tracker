//
//  SplashViewModel.swift
//  issueTracker
//
//  Created by seongha shin on 2022/06/13.
//

import Foundation
import RxCocoa
import RxRelay
import RxSwift

final class LoginViewModel: ViewModel {
    struct Action {
        let tappedGitLogin = PublishRelay<Void>()
        let inputDeeplinkQuery = PublishRelay<[URLQueryItem]?>()
    }
    
    struct State {
    }
    
    let action = Action()
    let state = State()
    private weak var coordinator: AuthViewCoordinator?
    
    private var disposeBag = DisposeBag()
    
    @Inject(\.tokenStore) private var tokenStore: TokenStore
    @Inject(\.gitHubRepository) private var gitHubRepository: GitHubRepository
    
    init(coordinator: AuthViewCoordinator) {
        self.coordinator = coordinator
        
        action.tappedGitLogin
            .bind(to: coordinator.openGithubUrl)
            .disposed(by: disposeBag)
        
        let requestAccessToken = action.inputDeeplinkQuery
            .compactMap { $0?.filter { $0.name == "code" }.first?.value }
            .withUnretained(self)
            .flatMapLatest { router, code in
                router.gitHubRepository.requestAccessToken(code: code)
            }
            .share()
        
        requestAccessToken
            .compactMap { $0.value }
            .withUnretained(self)
            .do { vm, token in
                vm.tokenStore.store(token)
            }
            .map { _ in }
            .bind(to: coordinator.loginSuccess)
            .disposed(by: disposeBag)
    }
}
