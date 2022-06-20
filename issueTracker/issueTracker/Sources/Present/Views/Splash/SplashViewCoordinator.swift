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
        let viewModel = SplashViewModel(navigation: self)
        viewController.viewModel = viewModel
        navigationController.pushViewController(viewController, animated: true)
    }
    func switchRootViewController(_ type: AppCoordinator.RootViewType) {
        let appCoordinator = parentCoordinator as? AppCoordinator
        appCoordinator?.switchRootViewController(type)
        parentCoordinator?.childDidFinish(self)
    }
}
