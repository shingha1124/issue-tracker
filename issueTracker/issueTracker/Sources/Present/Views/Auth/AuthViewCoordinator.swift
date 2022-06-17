//
//  SlpashViewCoordinator.swift
//  issueTracker
//
//  Created by seongha shin on 2022/06/13.
//

import UIKit

protocol AuthViewCoordinatorDelegate: AnyObject {
    func didFinishAuthCoordinator(coordinator: Coordinator)
}

final class AuthViewCoordinator: BaseCoordinator {
    private let navigationController: UINavigationController
    weak var delegate: AuthViewCoordinatorDelegate?
    
    lazy var loginViewController: LoginViewController = {
        let loginViewModel = LoginViewModel()
        loginViewModel.coordinatorDelegate = self
        let loginViewController = LoginViewController()
        loginViewController.viewModel = loginViewModel
        return loginViewController
    }()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    deinit {
        Log.debug("deinit \(String(describing: type(of: self)))")
    }
    
    override func start() {
        Log.debug("start \(String(describing: type(of: self)))")
        navigationController.setViewControllers([loginViewController], animated: false)
    }
    
    override func deepLink(path: [String], url: URL) {
        if path.isEmpty { return }
        let firstPath = path[0]
        
        switch firstPath {
        case "login":
            loginViewController.viewModel?.action.inputDeeplinkQuery.accept(url)
        default:
            break
        }
    }
}

extension AuthViewCoordinator: LoginViewModelCoordinatorDelegate {
    func didGithubLogin() {
        var urlComponets = URLComponents(string: Constants.Github.authorizeUrl)
        urlComponets?.queryItems = Constants.Github.authorizeQuery.map {
            URLQueryItem(name: $0.key, value: $0.value)
        }
        guard let openUrl = urlComponets?.url else {
            return
        }
        UIApplication.shared.open(openUrl)
    }
    
    func loginDidSuccess() {
        delegate?.didFinishAuthCoordinator(coordinator: self)
    }
}
