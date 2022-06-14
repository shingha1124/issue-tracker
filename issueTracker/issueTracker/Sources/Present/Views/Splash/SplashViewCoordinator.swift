//
//  SplashViewCoordinator.swift
//  issueTracker
//
//  Created by seongha shin on 2022/06/14.
//

import UIKit

final class SplashViewCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    deinit {
        Log.debug("deinit \(String(describing: type(of: self)))")
    }
    
    func start() {
        Log.debug("start \(String(describing: type(of: self)))")
        goToSplash()
    }
}

extension SplashViewCoordinator: SplashNavigation {
    func goToSplash() {
        let viewController = SplashViewController()
        let viewModel = SplashViewModel(splashNavigation: self)
        viewController.viewModel = viewModel
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func goToLogin() {
        let appCoordinator = parentCoordinator as? AppCoordinator
        appCoordinator?.switchRootViewController(.login)
        parentCoordinator?.childDidFinish(self)
    }
    
    func goToHome() {
        let appCoordinator = parentCoordinator as? AppCoordinator
        appCoordinator?.switchRootViewController(.home)
        parentCoordinator?.childDidFinish(self)
    }
}
