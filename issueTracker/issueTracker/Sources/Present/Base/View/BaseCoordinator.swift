//
//  BaseCoordinator.swift
//  issueTracker
//
//  Created by seongha shin on 2022/06/17.
//

import Foundation

class BaseCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    
    func start() { }
    func deepLink(path: [String], url: URL) { }
}
