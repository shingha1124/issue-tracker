//
//  MilestoneViewCoordinator.swift
//  issueTracker
//
//  Created by 이준우 on 2022/06/20.
//

import UIKit

final class MileStoneViewCoordinator: BaseCoordinator {
    
    var navigationController: UINavigationController
    
    init(navigation: UINavigationController) {
        self.navigationController = navigation
    }
    
    override func start() {
        let viewController = MilestoneListViewController()
        let viewModel = MilestoneListViewModel(navigation: self)
        viewController.viewModel = viewModel
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension MileStoneViewCoordinator: MilestoneListNavigation { }
