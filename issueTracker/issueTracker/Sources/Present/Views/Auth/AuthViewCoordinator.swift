//
//  SlpashViewCoordinator.swift
//  issueTracker
//
//  Created by seongha shin on 2022/06/13.
//

import RxRelay
import UIKit

final class AuthViewCoordinator: BaseCoordinator {
    private let navigationController: UINavigationController
    
    let openGithubUrl = PublishRelay<Void>()
    let loginSuccess = PublishRelay<Void>()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        super.init()
        bind()
    }
    
    deinit {
        Log.debug("deinit \(String(describing: type(of: self)))")
    }
    
    override func bind() {
        startView
            .bind(onNext: presentLoginView)
            .disposed(by: disposeBag)
        
        deepLinkHandler
            .filter { $0.path.contains(.login) }
            .withUnretained(self)
            .compactMap { coordinator, deeplink -> (LoginViewController, Deeplink)? in
                guard let loginViewController = coordinator.navigationController.visibleViewController as? LoginViewController else {
                    return nil
                }
                return (loginViewController, deeplink)
            }
            .bind(onNext: { loginView, deeplink in
                let viewModel = loginView.viewModel
                viewModel?.action.inputDeeplinkQuery.accept(deeplink.queryItems)
            })
            .disposed(by: disposeBag)
        
        openGithubUrl
            .compactMap { _ -> URL? in
                var urlComponets = URLComponents(string: Constants.Github.authorizeUrl)
                urlComponets?.queryItems = Constants.Github.authorizeQuery.map {
                    URLQueryItem(name: $0.key, value: $0.value)
                }
                return urlComponets?.url
            }
            .bind(onNext: {
                UIApplication.shared.open($0)
            })
            .disposed(by: disposeBag)
    }
}

extension AuthViewCoordinator {
    private func presentLoginView() {
        let loginViewModel = LoginViewModel(coordinator: self)
        let loginViewController = LoginViewController()
        loginViewController.viewModel = loginViewModel
        navigationController.setViewControllers([loginViewController], animated: false)
    }
}
