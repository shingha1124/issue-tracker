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
    
    func start() {
        print("start \(String(describing: type(of: self)))")
        goToLoginPage()
    }
    
    func goToLoginPage() {
        let loginViewController = LoginViewController()
        let loginViewModel = LoginViewModel(loginNavigation: self)
        loginViewController.viewModel = loginViewModel
        navigationController.pushViewController(loginViewController, animated: true)
    }
}

extension AuthViewCoordinator: LoginNavigation {
    func goToHome() {
    }
    
    func goToRegisterPage() {
    }
}
