//
//  AppCoordinator.swift
//  issueTracker
//
//  Created by seongha shin on 2022/06/13.
//

import UIKit

final class AppCoordinator: BaseCoordinator {
    var rootViewController: UINavigationController = {
        UINavigationController()
    }()
    
    private lazy var authCoordinator: AuthViewCoordinator = {
        let coordinator = AuthViewCoordinator(navigationController: rootViewController)
        store(coordinator: coordinator)
        return coordinator
    }()
    
    private lazy var homeCoordinator: HomeViewCoordinator = {
        let coordinator = HomeViewCoordinator(navigationController: rootViewController)
        store(coordinator: coordinator)
        return coordinator
    }()
    
    @Inject(\.tokenStore) private var tokenStore: TokenStore
    
    override init() {
        super.init()
        bind()
    }
    
    deinit {
        Log.debug("deinit \(String(describing: type(of: self)))")
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func bind() {
        let hasToken = startView
            .withUnretained(self)
            .map { $0.0.tokenStore.hasToken() }
        
        hasToken
            .filter { !$0 }
            .map { _ in }
            .bind(to: authCoordinator.startView)
            .disposed(by: disposeBag)
        
        hasToken
            .filter { $0 }
            .map { _ in }
            .bind(to: homeCoordinator.startView)
            .disposed(by: disposeBag)
         
        deepLinkHandler
            .filter { $0.path.contains(.auth) }
            .bind(to: authCoordinator.deepLinkHandler)
            .disposed(by: disposeBag)
        
        authCoordinator.loginSuccess
            .bind(to: homeCoordinator.startView)
            .disposed(by: disposeBag)
    }
}
