//
//  AppCoordinator.swift
//  issueTracker
//
//  Created by seongha shin on 2022/06/13.
//

import UIKit

final class AppCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    
    let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
        navigationController = UINavigationController()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func start() {
        print("start \(String(describing: type(of: self)))")
        window.overrideUserInterfaceStyle = .light
        switchRootWindow(.splash)
    }
    
    func switchRootWindow(_ type: RootViewType) {
        let coordinator = type.coordinator
        children.removeAll()
        coordinator.parentCoordinator = self
        navigationController = coordinator.navigationController
        children.append(coordinator)
        coordinator.start()
        window.rootViewController = navigationController
    }
}

extension AppCoordinator {
    enum RootViewType {
        case splash, login, home
        
        var coordinator: Coordinator {
            switch self {
            case .splash:
                return SplashViewCoordinator(navigationController: UINavigationController())
            case .login:
                return AuthViewCoordinator(navigationController: UINavigationController())
            case .home:
                return HomeViewCoordinator(navigationController: UINavigationController())
            }
        }
    }
}
