//
//  IssueListViewModel.swift
//  issueTracker
//
//  Created by seongha shin on 2022/06/13.
//

import Foundation
import RxSwift

protocol IssueListNavigation: AnyObject {
    
}

final class IssueListViewModel: ViewModel {
    struct Action {
        
    }
    
    struct State {
        
    }
    
    let action = Action()
    let state = State()
    
    private let disposeBag = DisposeBag()
    private weak var navigation: IssueListNavigation?
    
    init(navigation: IssueListNavigation) {
        self.navigation = navigation
    }
}
