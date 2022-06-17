//
//  HomeViewCoordinator.swift
//  issueTracker
//
//  Created by seongha shin on 2022/06/14.
//

import UIKit

protocol HomeViewCoordinatorDelegate: AnyObject {
    
}

final class HomeViewCoordinator: BaseCoordinator {
    private let issueCoordinator: IssueListViewCoordinator = {
        let issueNavigationController = UINavigationController()
        let issueCoordinator = IssueListViewCoordinator(navigation: issueNavigationController)
        issueNavigationController.tabBarItem = UITabBarItem(title: "이슈", image: UIImage(named: "ic_issue"), tag: 0)
        return issueCoordinator
    }()
    
    private let labelListCoordinator: LabelListViewCoordinator = {
        let labelListNavigationController = UINavigationController()
        let labelListCoordinator = LabelListViewCoordinator(navigation: labelListNavigationController)
        labelListNavigationController.tabBarItem = UITabBarItem(title: "레이블", image: UIImage(named: "ic_issue"), tag: 1)
        return labelListCoordinator
    }()
    
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    weak var delegate: HomeViewCoordinatorDelegate?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    deinit {
        Log.debug("deinit \(String(describing: type(of: self)))")
    }
    
    override func start() {
        Log.debug("start \(String(describing: type(of: self)))")
        initializeHomeTabBar()
    }
    
    private func initializeHomeTabBar() {
//        navigationController.setNavigationBarHidden(true, animated: false)
//        
//        let tabBarViewController = UITabBarController()
//        tabBarViewController.viewControllers = [issueCoordinator.navigationController, labelListCoordinator.navigationController]
//        
//        issueCoordinator.parentCoordinator = parentCoordinator
//        labelListCoordinator.parentCoordinator = parentCoordinator
//        
//        parentCoordinator?.children.append(issueCoordinator)
//        parentCoordinator?.children.append(labelListCoordinator)
//        
//        navigationController.pushViewController(tabBarViewController, animated: true)
//        
//        issueCoordinator.start()
//        labelListCoordinator.start()
    }
}
