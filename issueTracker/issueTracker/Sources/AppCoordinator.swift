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
        deepLinkHandler
            .filter { $0.path.contains(.auth) }
            .bind(to: loginFlow().deepLinkHandler)
            .disposed(by: disposeBag)
    }
    
    override func start() {
        Log.debug("start \(String(describing: type(of: self)))")
        if tokenStore.hasToken() {
            homeFlow()
        } else {
            loginFlow()
        }
    }
    
    @discardableResult
    private func loginFlow() -> BaseCoordinator {
        if let coordinator = self.find(type: AuthViewCoordinator.self) {
            return coordinator
        }
        
        let coordinator = AuthViewCoordinator(navigationController: rootViewController)
        coordinator.delegate = self
        clear()
        store(coordinator: coordinator)
        coordinator.start()
        return coordinator
    }
    
    @discardableResult
    private func homeFlow() -> BaseCoordinator {
        if let coordinator = self.find(type: HomeViewCoordinator.self) {
            return coordinator
        }
        
        let coordinator = HomeViewCoordinator(navigationController: rootViewController)
        coordinator.delegate = self
        clear()
        store(coordinator: coordinator)
        coordinator.start()
        return coordinator
    }
}

extension AppCoordinator: AuthViewCoordinatorDelegate {
    func didFinishAuthCoordinator(coordinator: Coordinator) {
        free(coordinator: coordinator)
        homeFlow()
    }
}

extension AppCoordinator: HomeViewCoordinatorDelegate {
}
