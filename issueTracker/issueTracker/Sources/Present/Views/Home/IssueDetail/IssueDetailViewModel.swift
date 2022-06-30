//
//  IssueDetailViewModel.swift
//  issueTracker
//
//  Created by 이준우 on 2022/06/29.
//
import Foundation
import RxRelay
import RxSwift

final class IssueDetailViewModel: ViewModel {
    struct Action {
        let loadData = PublishRelay<Void>()
        let viewDidLoad = PublishRelay<Void>()
    }
    struct State {
        let issue = PublishRelay<Issue>()
        let issueTitle = PublishRelay<String>()
        let issueState = PublishRelay<Issue.State>()
        let issueNumber = PublishRelay<Int>()
        let issueDate = PublishRelay<Date>()
    }
    
    let action = Action()
    let state = State()
    
    private let disposeBag = DisposeBag()
    private weak var coordinator: IssueListViewCoordinator?

    init(coordinator: IssueListViewCoordinator, issue: Issue) {
        self.coordinator = coordinator
        
        action.loadData
            .map { issue.title }
            .bind(to: state.issueTitle)
            .disposed(by: disposeBag)
        
        action.loadData
            .map { issue.state }
            .bind(to: state.issueState)
            .disposed(by: disposeBag)
        
        action.loadData
            .map { issue.number }
            .bind(to: state.issueNumber)
            .disposed(by: disposeBag)
        
        action.loadData
            .map { issue.updatedAt }
            .bind(to: state.issueDate)
            .disposed(by: disposeBag)
    }
}
