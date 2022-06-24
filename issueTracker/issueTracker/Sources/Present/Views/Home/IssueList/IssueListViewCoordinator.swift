//
//  IssueListViewCoordinator.swift
//  issueTracker
//
//  Created by seongha shin on 2022/06/14.
//

import RxRelay
import UIKit

final class IssueListViewCoordinator: BaseCoordinator {
    var navigationController: UINavigationController
    
    let goToAddIssue = PublishRelay<Void>()
    
    init(navigation: UINavigationController) {
        self.navigationController = navigation
        super.init()
        bind()
    }
    
    override func bind() {
        startView
            .bind(onNext: presentIssueListView)
            .disposed(by: disposeBag)
        
        goToAddIssue
            .bind(onNext: presentAddIssue)
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
    
    private func presentAddIssue() {
        navigationController.topViewController?.navigationItem.backButtonTitle = "Cancel".localized()
        let viewController = AddIssueViewController()
        let viewModel = AddIssueViewModel(coordinator: self)
        viewController.viewModel = viewModel
        navigationController.pushViewController(viewController, animated: true)
    }
}
