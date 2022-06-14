//
//  Container.swift
//  Starbucks
//
//  Created by seongha shin on 2022/05/11.
//

import Foundation

class Container {
    static var shared = Container()
    
    private init() { }
    
    lazy var authRepository: GitHubRepository = GitHubRepositoryImpl()
    
    lazy var imageManager = ImageManager()
    
    lazy var tokenStore = TokenStore()
}
