//
//  MilestoneInsertViewModel.swift
//  issueTracker
//
//  Created by 이준우 on 2022/06/21.
//

import Foundation
import RxRelay
import RxSwift

final class MilestoneInsertViewModel: ViewModel {
    private enum Constants {
        static let owner = "shingha1124"
        static let repo = "issue-tracker"
    }
    
    struct Action {}
    struct State {}
    
    let action = Action()
    let state = State()
    private let disposeBag = DisposeBag()
    
    
}
