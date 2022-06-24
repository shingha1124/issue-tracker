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
        super.init()
        bind()
    }
    
    override func bind() {
        startView
            .bind(onNext: presentIssueListView)
            .disposed(by: disposeBag)
    }
}

extension IssueListViewCoordinator {
    private func presentIssueListView() {
        let viewController = IssueListViewController()
        let viewModel = IssueListViewModel(coordinator: self)
        viewController.viewModel = viewModel
        navigationController.pushViewController(viewController, animated: true)
    }
}
