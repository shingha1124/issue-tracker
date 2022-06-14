//
//  IssueListViewModel.swift
//  issueTracker
//
//  Created by seongha shin on 2022/06/13.
//

import Foundation
import RxRelay
import RxSwift

protocol IssueListNavigation: AnyObject {
    
}

final class IssueListViewModel: ViewModel {
    
    private enum Constants {
        static let owner = "shingha1124"
        static let repo = "issue-tracker"
    }
    
    struct Action {
        let requestIssue = PublishRelay<Void>()
        let deleteIssue = PublishRelay<Int>()
    }
    
    struct State {
        let issues = PublishRelay<[IssueTableViewCellModel]>()
    }
    
    let action = Action()
    let state = State()
    
    private let disposeBag = DisposeBag()
    private weak var navigation: IssueListNavigation?
    @Inject(\.gitHubRepository) private var gitHubRepository: GitHubRepository
    
    init(navigation: IssueListNavigation) {
        self.navigation = navigation
        
        let requestIssueList = action.requestIssue
            .map {
                RequestIssueListParameters(owner: Constants.owner, repo: Constants.repo, parameters: nil)
            }
            .withUnretained(self)
            .flatMapLatest { model, param in
                model.gitHubRepository.requestIssueList(parameters: param)
            }
            .share()
        
        let issueCellViewModels = requestIssueList
            .compactMap { $0.value }
            .map { $0.map { IssueTableViewCellModel(issue: $0) } }
            .share()
        
        issueCellViewModels
            .bind(to: state.issues)
            .disposed(by: disposeBag)
        
        let requestIssueClose = action.deleteIssue
            .withLatestFrom(state.issues) { index, viewModels in
                viewModels[index].state.issue.number
            }
            .map {
                RequestUpdateIssueParameters(owner: Constants.owner, repo: Constants.repo, number: $0, parameters: ["state": Issue.State.closed.value])
            }
            .withUnretained(self)
            .flatMapLatest { model, param in
                model.gitHubRepository.requestUpdateIssue(parameters: param)
            }
            .share()
        
        requestIssueClose
            .compactMap { $0.value }
            .bind(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
    }
}
