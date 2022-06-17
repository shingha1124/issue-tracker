//
//  IssueListViewCoordinator.swift
//  issueTracker
//
//  Created by seongha shin on 2022/06/14.
//

import UIKit

final class IssueListViewCoordinator: BaseCoordinator {
    var navigationController: UINavigationController
    
    init(navigation: UINavigationController) {
        self.navigationController = navigation
    }
    
    override func start() {
        let viewController = IssueListViewController()
        let viewModel = IssueListViewModel(navigation: self)
        viewController.viewModel = viewModel
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension IssueListViewCoordinator: IssueListNavigation {
    func goToIssueList() {
    }
}
