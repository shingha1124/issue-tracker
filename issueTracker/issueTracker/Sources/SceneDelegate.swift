//
//  SceneDelegate.swift
//  issueTracker
//
//  Created by seongha shin on 2022/06/13.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: scene)
        self.window = window
        appCoordinator = AppCoordinator(window)
        appCoordinator?.start()
    }
}
