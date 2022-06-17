//
//  LabelViewCoordinator.swift
//  issueTracker
//
//  Created by 이준우 on 2022/06/14.
//

import UIKit

final class LabelListViewCoordinator: BaseCoordinator {
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigation: UINavigationController) {
        self.navigationController = navigation
    }
    
    override func start() {
        goToLabelList()
    }
}

extension LabelListViewCoordinator: LabelListNavigation {

    func goToLabelList() {
        let viewController = LabelListViewController()
        let viewModel = LabelListViewModel(navigation: self)
        viewController.viewModel = viewModel
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func goToLabelInsertion() {
        let viewController = LabelInsertViewController()
        let viewModel = LabelInsertViewModel(navigation: self)
        viewController.viewModel = viewModel
        navigationController.pushViewController(viewController, animated: true)
    }
}
