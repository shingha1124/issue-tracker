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
        
        appCoordinator = AppCoordinator()
        appCoordinator?.startView.accept(())
        
        self.window?.overrideUserInterfaceStyle = .light
        self.window?.rootViewController = appCoordinator?.rootViewController
        self.window?.makeKeyAndVisible()
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else {
            return
        }
        //issue-tracker://
        //host:  github
        //path: /auth/login
        //query: ?code=12312312465342
        appCoordinator?.deepLinkHandler.accept(Deeplink(url: url))
    }
}
