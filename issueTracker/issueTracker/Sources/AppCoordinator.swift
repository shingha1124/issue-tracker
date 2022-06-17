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
    
    private let window: UIWindow
    
    @Inject(\.tokenStore) private var tokenStore: TokenStore
    
    init(window: UIWindow) {
        self.window = window
    }
    
    deinit {
        Log.debug("deinit \(String(describing: type(of: self)))")
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func start() {
        Log.debug("start \(String(describing: type(of: self)))")
        window.overrideUserInterfaceStyle = .light
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
        
        if tokenStore.hasToken() {
            homeFlow()
        } else {
            loginFlow()
        }
    }
    
    override func deepLink(path: [String], url: URL) {
        if path.isEmpty { return }
        let firstPath = path[0]
        let nextPath = Array(path.dropFirst())
        
        switch firstPath {
        case "auth":
            let coordinator = find(type: AuthViewCoordinator.self)
            coordinator?.deepLink(path: nextPath, url: url)
        default:
            break
        }
    }
    
    private func loginFlow() {
        let coordinator = AuthViewCoordinator(navigationController: rootViewController)
        coordinator.delegate = self
        store(coordinator: coordinator)
        coordinator.start()
    }
    
    private func homeFlow() {
        let coordinator = HomeViewCoordinator(navigationController: rootViewController)
        coordinator.delegate = self
        store(coordinator: coordinator)
        coordinator.start()
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
