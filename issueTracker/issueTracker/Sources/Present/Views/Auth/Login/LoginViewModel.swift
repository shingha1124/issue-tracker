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

protocol LoginNavigation: AnyObject {
    func goToHome()
    func goToRegisterPage()
}

final class LoginViewModel: ViewModel {
    struct Action {
        let checkLogin = PublishRelay<Void>()
    }
    
    struct State {
    }
    
    let action = Action()
    let state = State()
    private weak var loginNavigation: LoginNavigation?
    
    private var disposeBag = DisposeBag()
    
    init(loginNavigation: LoginNavigation) {
        self.loginNavigation = loginNavigation
        
        action.checkLogin
            .withUnretained(self)
            .bind(onNext: { model, _ in
                model.loginNavigation?.goToHome()
            })
            .disposed(by: disposeBag)
    }
}
