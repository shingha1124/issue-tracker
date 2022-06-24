//
//  MilestoneTableViewModel.swift
//  issueTracker
//
//  Created by 이준우 on 2022/06/20.
//

import Foundation
import RxRelay
import RxSwift

final class MilestoneTableViewCellModel: ViewModel {
    
    struct Action {
        let loadData = PublishRelay<Void>()
    }
    
    struct State {
        let title = PublishRelay<String>()
        let description = PublishRelay<String>()
        let deadline = PublishRelay<Date?>()
        let openedIssueCount = PublishRelay<Int>()
        let closedIssueCount = PublishRelay<Int>()
        let progress = PublishRelay<Float>()
    }
    
    let action = Action()
    let state = State()
    private let disposeBag = DisposeBag()
    
    init(milestone: Milestone) {
        action.loadData
            .map { milestone.title }
            .bind(to: state.title)
            .disposed(by: disposeBag)
        
        action.loadData
            .map { milestone.description }
            .bind(to: state.description)
            .disposed(by: disposeBag)
        
        action.loadData
            .map { milestone.deadline }
            .bind(to: state.deadline)
            .disposed(by: disposeBag)
        
        action.loadData
            .map { milestone.openedIssueCount }
            .bind(to: state.openedIssueCount)
            .disposed(by: disposeBag)
        
        action.loadData
            .map { milestone.closedIssueCount }
            .bind(to: state.closedIssueCount)
            .disposed(by: disposeBag)
        
        Observable
            .combineLatest(state.openedIssueCount.asObservable(), state.closedIssueCount.asObservable())
            .map { opendCount, closedCount in
                let totalCount = opendCount + closedCount
                let progress = Float(closedCount) / Float(totalCount)
                return progress.isNaN ? 0 : progress * 100
            }
            .bind(to: state.progress)
            .disposed(by: disposeBag)
    }
}
