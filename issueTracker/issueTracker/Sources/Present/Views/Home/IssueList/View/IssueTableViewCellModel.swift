//
//  IssueTableViewCellModel.swift
//  issueTracker
//
//  Created by seongha shin on 2022/06/14.
//

import Foundation
import RxRelay
import RxSwift

final class IssueTableViewCellModel: ViewModel {
    struct Action {
        let loadData = PublishRelay<Void>()
    }
    
    struct State {
        let issue: Issue
        let title = PublishRelay<String>()
        let body = PublishRelay<String?>()
        let milestone = PublishRelay<String?>()
        let labels = PublishRelay<[Label]>()
    }
    
    let action = Action()
    let state: State
    
    private let disposeBag = DisposeBag()
    
    init(issue: Issue) {
        state = State(issue: issue)
        
        action.loadData
            .map { issue.title }
            .bind(to: state.title)
            .disposed(by: disposeBag)
        
        action.loadData
            .map { issue.body }
            .bind(to: state.body)
            .disposed(by: disposeBag)
        
        action.loadData
            .map { issue.milestone?.title }
            .bind(to: state.milestone)
            .disposed(by: disposeBag)
        
        action.loadData
            .map { issue.labels ?? [] }
            .bind(to: state.labels)
            .disposed(by: disposeBag)
    }
}
