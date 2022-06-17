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
}

final class LoginViewModel: ViewModel {
    struct Action {
        let tappedGitLogin = PublishRelay<Void>()
    }
    
    struct State {
    }
    
    let action = Action()
    let state = State()
    weak var coordinatorDelegate: LoginViewModelCoordinatorDelegate?
    
    private var disposeBag = DisposeBag()
    
    init() {
        action.tappedGitLogin
            .withUnretained(self)
            .bind(onNext: { vm, _ in
                vm.coordinatorDelegate?.didGithubLogin()
            })
            .disposed(by: disposeBag)
    }
}
