//
//  MilestoneViewCoordinator.swift
//  issueTracker
//
//  Created by 이준우 on 2022/06/20.
//

import RxRelay
import UIKit

final class MileStoneViewCoordinator: BaseCoordinator {
    var navigationController: UINavigationController
    
    let goToMilestoneInsertion = PublishRelay<Void>()
    let dismiss = PublishRelay<Void>()
    
    init(navigation: UINavigationController) {
        self.navigationController = navigation
        super.init()
        bind()
    }
    
    override func bind() {
        startView
            .bind(onNext: presentMilestoneListView)
            .disposed(by: disposeBag)
        
        goToMilestoneInsertion
            .bind(onNext: presentInsertion)
            .disposed(by: disposeBag)
        
        dismiss
            .bind(onNext: presentedViewDismiss)
            .disposed(by: disposeBag)
    }
}

extension MileStoneViewCoordinator {
    private func presentMilestoneListView() {
        let viewController = MilestoneListViewController()
        let viewModel = MilestoneListViewModel(coordinator: self)
        viewController.viewModel = viewModel
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func presentInsertion() {
        let viewModel = MilestoneInsertViewModel(coordinator: self)
        let viewController = MilestoneInsertViewController()
        viewController.viewModel = viewModel
        let childNavigation = UINavigationController(rootViewController: viewController)
        navigationController.present(childNavigation, animated: true)
    }
    
    private func presentedViewDismiss() {
        navigationController.presentedViewController?.dismiss(animated: true)
    }
}
