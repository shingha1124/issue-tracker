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
    }
    
    let action = Action()
    let state = State()
    private weak var loginNavigation: LoginNavigation?
    
    private var disposeBag = DisposeBag()
    
    init(loginNavigation: LoginNavigation) {
        self.loginNavigation = loginNavigation
        
        action.tappedGitLogin
            .compactMap { _ -> URL? in
                let clientId = Constants.Login.gitHubClientId
                var urlComponets = URLComponents(string: Constants.Login.gitHubUrl)
                urlComponets?.queryItems = [
                    URLQueryItem(name: "client_id", value: clientId),
                    URLQueryItem(name: "scope", value: "repo,user")
                ]
                return urlComponets?.url
            }
            .bind(onNext: {
                UIApplication.shared.open($0)
            })
            .disposed(by: disposeBag)
    }
}
