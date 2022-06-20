//
//  LabelViewCoordinator.swift
//  issueTracker
//
//  Created by 이준우 on 2022/06/14.
//

import UIKit

final class LabelListViewCoordinator: BaseCoordinator {
    var navigationController: UINavigationController
    
    init(navigation: UINavigationController) {
        self.navigationController = navigation
    }
    
    override func start() {
        let viewController = LabelListViewController()
        let viewModel = LabelListViewModel(navigation: self)
        viewController.viewModel = viewModel
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension LabelListViewCoordinator: LabelListNavigation {
    
    func goToLabelInsertion() {
        let viewController = LabelInsertViewController()
        let viewModel = LabelInsertViewModel(navigation: self)
        viewController.viewModel = viewModel
        let childNavigation = UINavigationController(rootViewController: viewController)
        navigationController.present(childNavigation, animated: true)
    }
    
    func goBackToLabelList() {
        navigationController.presentedViewController?.dismiss(animated: true)
    }
}
