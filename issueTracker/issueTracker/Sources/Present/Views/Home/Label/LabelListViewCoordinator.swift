//
//  LabelViewCoordinator.swift
//  issueTracker
//
//  Created by 이준우 on 2022/06/14.
//

import UIKit

final class LabelListViewCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    
    var children: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigation: UINavigationController) {
        self.navigationController = navigation
    }
    
    func start() {
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
        
    }
}
