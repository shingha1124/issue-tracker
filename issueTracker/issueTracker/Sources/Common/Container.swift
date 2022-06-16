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
    
    let gitHubRepository: GitHubRepository = GitHubRepositoryImpl()
    
    let coreDataRepository = CoreDataRepository()
    
    let imageManager = ImageManager()
    
    let tokenStore = TokenStore()
}
