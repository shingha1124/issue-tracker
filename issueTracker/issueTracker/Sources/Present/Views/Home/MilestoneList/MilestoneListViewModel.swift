//
//  MilestoneListViewModel.swift
//  issueTracker
//
//  Created by 이준우 on 2022/06/20.
//

import Foundation
import RxCocoa
import RxRelay
import RxSwift

protocol MilestoneListNavigation: AnyObject {
    
}

final class MilestoneListViewModel: ViewModel {
    
    struct Action {}
    struct State {}
    
    let action = Action()
    let state = State()
    
    private let disposeBag = DisposeBag()
    private weak var navigation: MilestoneListNavigation?
    
    init(navigation: MilestoneListNavigation) {
        self.navigation = navigation
    }
}
