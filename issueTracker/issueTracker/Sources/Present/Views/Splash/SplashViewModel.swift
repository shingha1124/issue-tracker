//
//  SplashViewModel.swift
//  issueTracker
//
//  Created by seongha shin on 2022/06/14.
//

import Foundation
import RxRelay
import RxSwift

protocol SplashNavigation: AnyObject {
    func switchRootViewController(_ type: AppCoordinator.RootViewType)
}

final class SplashViewModel: ViewModel {
    struct Action {
        let checkToken = PublishRelay<Void>()
    }
    
    struct State {
    }
    
    let action = Action()
    let state = State()
    
    private weak var navigation: SplashNavigation?
    private var disposeBag = DisposeBag()
    @Inject(\.tokenStore) private var tokenStore: TokenStore
    
    init(navigation: SplashNavigation) {
        self.navigation = navigation
        
        action.checkToken
            .withUnretained(self)
            .map { model, _ in
                model.tokenStore.hasToken() ? .home : .login
            }
            .withUnretained(self)
            .bind(onNext: { model, type in
                model.navigation?.switchRootViewController(type)
            })
            .disposed(by: disposeBag)
    }
}
