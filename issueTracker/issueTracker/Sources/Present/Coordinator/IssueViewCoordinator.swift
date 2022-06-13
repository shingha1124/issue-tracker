//
//  FirstViewCoordinator.swift
//  issueTracker
//
//  Created by seongha shin on 2022/06/13.
//

import UIKit

final class IssueViewCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init() {
        self.navigationController = .init()
    }
    
    func start() {
        
    }
    
    func startPush() -> UINavigationController {
        let issueListViewController = IssueListViewController()
        issueListViewController.viewModel = IssueListViewModel()
        navigationController.setViewControllers([issueListViewController], animated: false)
        return navigationController
    }
}
