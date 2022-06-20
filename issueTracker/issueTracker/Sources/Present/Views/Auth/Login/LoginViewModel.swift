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
        let tappedGitLogin = PublishRelay<Void>()
    }
    
    struct State {
        let presentGitLogin = PublishRelay<URL>()
    }
    
    let action = Action()
    let state = State()
    private weak var loginNavigation: LoginNavigation?
    
    private var disposeBag = DisposeBag()
    
    init(loginNavigation: LoginNavigation) {
        self.loginNavigation = loginNavigation
        
        action.tappedGitLogin
            .compactMap { _ -> URL? in
                var urlComponets = URLComponents(string: Constants.Github.authorizeUrl)
                urlComponets?.queryItems = Constants.Github.authorizeQuery.map {
                    URLQueryItem(name: $0.key, value: $0.value)
                }
                return urlComponets?.url
            }
            .bind(to: state.presentGitLogin)
            .disposed(by: disposeBag)
    }
}
