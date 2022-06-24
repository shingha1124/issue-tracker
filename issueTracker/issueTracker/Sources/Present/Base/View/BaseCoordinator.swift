//
//  BaseCoordinator.swift
//  issueTracker
//
//  Created by seongha shin on 2022/06/17.
//

import Foundation
import RxRelay
import RxSwift

class BaseCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    
    let deepLinkHandler = PublishRelay<Deeplink>()
    let startView = PublishRelay<Void>()
    let disposeBag = DisposeBag()
    
    func bind() { }
}
