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
        
        tabBarViewController.viewControllers = [issueNavigationController]
        
        parentCoordinator?.children.append(issueCoordinator)
        
        issueCoordinator.start()
    }
}
