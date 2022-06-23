//
//  HomeViewCoordinator.swift
//  issueTracker
//
//  Created by seongha shin on 2022/06/14.
//

import UIKit

final class HomeViewCoordinator: BaseCoordinator {
    private let issueCoordinator: IssueListViewCoordinator = {
        let issueNavigationController = UINavigationController()
        let issueCoordinator = IssueListViewCoordinator(navigation: issueNavigationController)
        issueNavigationController.tabBarItem = UITabBarItem(title: "Issue".localized(), image: UIImage(named: "ic_issue"), tag: 0)
        return issueCoordinator
    }()
    
    private let labelListCoordinator: LabelListViewCoordinator = {
        let labelListNavigationController = UINavigationController()
        let labelListCoordinator = LabelListViewCoordinator(navigation: labelListNavigationController)
        labelListNavigationController.tabBarItem = UITabBarItem(title: "Labels".localized(), image: UIImage(named: "ic_label"), tag: 1)
        return labelListCoordinator
    }()

    private let milestoneCoordinator: MileStoneViewCoordinator = {
        let milestoneNavigationController = UINavigationController()
        let milestoneCoordinator = MileStoneViewCoordinator(navigation: milestoneNavigationController)
        milestoneNavigationController.tabBarItem = UITabBarItem(title: "Milestone".localized(), image: UIImage(named: "ic_milestone"), tag: 2)
        return milestoneCoordinator
    }()
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        super.init()
        bind()
    }
    
    deinit {
        Log.debug("deinit \(String(describing: type(of: self)))")
    }
    
    override func bind() {
        startView
            .bind(onNext: initializeHomeTabBar)
            .disposed(by: disposeBag)
    }
}

extension HomeViewCoordinator {
    private func initializeHomeTabBar() {
        navigationController.setNavigationBarHidden(true, animated: false)

        let tabBarViewController = UITabBarController()
        tabBarViewController.viewControllers = [issueCoordinator.navigationController, labelListCoordinator.navigationController, milestoneCoordinator.navigationController]
        
        store(coordinator: issueCoordinator)
        store(coordinator: labelListCoordinator)
        store(coordinator: milestoneCoordinator)
        
        issueCoordinator.startView.accept(())
        labelListCoordinator.startView.accept(())
        milestoneCoordinator.startView.accept(())
        
        navigationController.setViewControllers([tabBarViewController], animated: false)
    }
}
