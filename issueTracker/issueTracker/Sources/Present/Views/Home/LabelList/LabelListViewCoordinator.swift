//
//  LabelViewCoordinator.swift
//  issueTracker
//
//  Created by 이준우 on 2022/06/14.
//

import RxRelay
import UIKit

final class LabelListViewCoordinator: BaseCoordinator {
    var navigationController: UINavigationController
    
    let goToLabelInserticon = PublishRelay<Void>()
    let dismiss = PublishRelay<Void>()
    
    init(navigation: UINavigationController) {
        self.navigationController = navigation
        super.init()
        bind()
    }
    
    override func bind() {
        startView
            .bind(onNext: presentLabelListView)
            .disposed(by: disposeBag)
        
        goToLabelInserticon
            .bind(onNext: presentInsertion)
            .disposed(by: disposeBag)
        
        dismiss
            .bind(onNext: presentedViewDismiss)
            .disposed(by: disposeBag)
    }
}

extension LabelListViewCoordinator {
    private func presentLabelListView() {
        let viewController = LabelListViewController()
        let viewModel = LabelListViewModel(coordinator: self)
        viewController.viewModel = viewModel
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func presentInsertion() {
        let viewController = LabelInsertViewController()
        let viewModel = LabelInsertViewModel(coordinator: self)
        viewController.viewModel = viewModel
        let childNavigation = UINavigationController(rootViewController: viewController)
        navigationController.present(childNavigation, animated: true)
    }
    
    private func presentedViewDismiss() {
        navigationController.presentedViewController?.dismiss(animated: true)
    }
}
