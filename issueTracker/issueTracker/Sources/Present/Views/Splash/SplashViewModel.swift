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
    func goToLogin()
    func goToHome()
}

final class SplashViewModel: ViewModel {
    struct Action {
        let checkToken = PublishRelay<Void>()
    }
    
    struct State {
        
    }
    
    let action = Action()
    let state = State()
    private weak var splashNavigation: SplashNavigation?
    
    private var disposeBag = DisposeBag()
    
    init(splashNavigation: SplashNavigation) {
        self.splashNavigation = splashNavigation
        
        action.checkToken
            .delay(.seconds(5), scheduler: MainScheduler.asyncInstance)
            .withUnretained(self)
            .bind(onNext: { model, _ in
                model.splashNavigation?.goToLogin()
            })
            .disposed(by: disposeBag)
    }
}
