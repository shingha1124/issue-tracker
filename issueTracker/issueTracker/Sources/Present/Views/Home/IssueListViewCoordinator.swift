//
//  IssueListViewCoordinator.swift
//  issueTracker
//
//  Created by seongha shin on 2022/06/14.
//

import RxRelay
import UIKit

final class IssueListViewCoordinator: BaseCoordinator {
    
    struct Present {
        let addIssue = PublishRelay<Void>()
        let issueDetail = PublishRelay<Issue>()
        let issueDetailPopover = PublishRelay<Issue>()
    }
    
    var navigationController: UINavigationController
    let present = Present()
    
    init(navigation: UINavigationController) {
        self.navigationController = navigation
        super.init()
        bind()
    }
    
    override func bind() {
        startView
            .bind(onNext: presentIssueListView)
            .disposed(by: disposeBag)
        
        present.addIssue
            .bind(onNext: presentAddIssue)
            .disposed(by: disposeBag)
        
        present.issueDetail
            .withUnretained(self)
            .bind(onNext: { coordinator, issue in
                coordinator.presentIssueDetailView(issue: issue)
            })
            .disposed(by: disposeBag)
        
        present.issueDetailPopover
            .bind(onNext: presentIssueDetailPopover)
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
    
    private func presentIssueDetailView(issue: Issue) {
        let viewModel = IssueDetailViewModel(coordinator: self, issue: issue)
        let viewController = IssueDetailViewController()
        viewController.viewModel = viewModel
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func presentIssueDetailPopover(issue: Issue) {
        let viewModel = IssueDetailPopoverViewModel(issue: issue)
        let viewController = IssueDetailPopoverViewController()
        viewController.viewModel = viewModel
        navigationController.present(viewController, animated: true)
    }
}
