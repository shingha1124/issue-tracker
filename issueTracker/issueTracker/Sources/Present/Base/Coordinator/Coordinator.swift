//
//  Coordinator.swift
//  issueTracker
//
//  Created by seongha shin on 2022/06/13.
//

import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    
    func start()
}
