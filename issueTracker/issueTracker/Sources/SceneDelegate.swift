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
        
        appCoordinator = AppCoordinator(window: window)
        appCoordinator?.start()
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else {
            return
        }
        appCoordinator?.deepLinkHandler.accept(DeepLink(url: url))
//        appCoordinator?.deeplink(deeplink: DeepLink(url: url))
    }
}

struct DeepLink {
    let path: [DeepLinkDestination]
    let queryItems: [URLQueryItem]?
    
    init(url: URL) {
        path = Array(url.path.split(separator: "/").compactMap {
            DeepLinkDestination.init(rawValue: String($0))
        })
        queryItems = URLComponents(string: url.absoluteString)?.queryItems
    }
    
    init(path: [DeepLinkDestination], queryItems: [URLQueryItem]?) {
        self.path = path
        self.queryItems = queryItems
    }
}

enum DeepLinkDestination: String {
    case auth
    case login
    
    var coordinatorType: BaseCoordinator.Type? {
        switch self {
        case .auth:
            return AuthViewCoordinator.self
        default:
            return nil
        }
    }
}
