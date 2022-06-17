//
//  SlpashViewCoordinator.swift
//  issueTracker
//
//  Created by seongha shin on 2022/06/13.
//

import UIKit

final class AuthViewCoordinator: Coordinator {
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
        goToLoginPage()
    }
}

extension AuthViewCoordinator: LoginNavigation {
    func goToLoginPage() {
        let loginViewController = LoginViewController()
        let loginViewModel = LoginViewModel(loginNavigation: self)
        loginViewController.viewModel = loginViewModel
        navigationController.pushViewController(loginViewController, animated: true)
    }
    
    func goToHome() {
    }
    
    func goToRegisterPage() {
    }
}
