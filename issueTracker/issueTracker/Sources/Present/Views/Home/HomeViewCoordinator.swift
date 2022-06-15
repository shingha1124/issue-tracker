//
//  HomeViewCoordinator.swift
//  issueTracker
//
//  Created by seongha shin on 2022/06/14.
//

import UIKit

final class HomeViewCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    deinit {
        Log.debug("deinit \(String(describing: type(of: self)))")
    }
    
    func start() {
        Log.debug("start \(String(describing: type(of: self)))")
        initializeHomeTabBar()
    }
    
    private func initializeHomeTabBar() {
        let tabBarViewController = UITabBarController()
        
        let issueNavigationController = UINavigationController()
        let issueCoordinator = IssueListViewCoordinator(navigation: issueNavigationController)
        issueCoordinator.parentCoordinator = parentCoordinator
        issueNavigationController.tabBarItem = UITabBarItem(title: "이슈", image: UIImage(named: "ic_issue"), tag: 0)
        
        let labelListNavigationController = UINavigationController()
        let labelListCoordinator = LabelListViewCoordinator(navigation: labelListNavigationController)
        labelListCoordinator.parentCoordinator = parentCoordinator
        labelListNavigationController.tabBarItem = UITabBarItem(title: "레이블", image: UIImage(named: "ic_issue"), tag: 1)
        
        navigationController.setNavigationBarHidden(true, animated: false)
        tabBarViewController.viewControllers = [issueNavigationController, labelListNavigationController]
        
        navigationController.pushViewController(tabBarViewController, animated: true)
        parentCoordinator?.children.append(issueCoordinator)
        parentCoordinator?.children.append(labelListCoordinator)
        
        issueCoordinator.start()
        labelListCoordinator.start()
    }
}
