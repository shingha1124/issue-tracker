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

protocol LoginViewModelCoordinatorDelegate: AnyObject {
    func didGithubLogin()
    func loginDidSuccess()
}

final class LoginViewModel: ViewModel {
    struct Action {
        let tappedGitLogin = PublishRelay<Void>()
        let inputDeeplinkQuery = PublishRelay<URL>()
    }
    
    struct State {
    }
    
    let action = Action()
    let state = State()
    weak var coordinatorDelegate: LoginViewModelCoordinatorDelegate?
    
    private var disposeBag = DisposeBag()
    
    @Inject(\.tokenStore) private var tokenStore: TokenStore
    @Inject(\.gitHubRepository) private var gitHubRepository: GitHubRepository
    
    init() {
        action.tappedGitLogin
            .withUnretained(self)
            .bind(onNext: { vm, _ in
                vm.coordinatorDelegate?.didGithubLogin()
            })
            .disposed(by: disposeBag)
        
        let requestAccessToken = action.inputDeeplinkQuery
            .compactMap { URLComponents(string: $0.absoluteString) }
            .compactMap { $0.queryItems?.filter { $0.name == "code" }.first?.value }
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
            .bind(onNext: { vc, _ in
                vc.coordinatorDelegate?.loginDidSuccess()
            })
            .disposed(by: disposeBag)
    }
}
