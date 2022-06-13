//
//  AppCoordinator.swift
//  issueTracker
//
//  Created by seongha shin on 2022/06/13.
//

import UIKit

final class AppCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    private let window: UIWindow
    
    init(_ window: UIWindow) {
        self.window = window
        window.makeKeyAndVisible()
    }
    
    func start() {
        let tabBarController = setTabBarController()
        window.rootViewController = tabBarController
    }
    
    private func setTabBarController() -> UITabBarController {
        let tabBarController = UITabBarController()
        
        let issueViewCoordinator = IssueViewCoordinator()
        issueViewCoordinator.parentCoordinator = self
        childCoordinators.append(issueViewCoordinator)
        let issueViewController = issueViewCoordinator.startPush()
        issueViewController.tabBarItem = UITabBarItem(title: "이슈", image: UIImage(named: "ic_issue"), tag: 0)
        
        tabBarController.viewControllers = [issueViewController]
        
        return tabBarController
    }
}
