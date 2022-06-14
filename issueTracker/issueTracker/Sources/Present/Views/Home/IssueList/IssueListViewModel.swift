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
    struct Action {
        let requestIssue = PublishRelay<Void>()
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
            .withUnretained(self)
            .flatMapLatest { model, _ in
                model.gitHubRepository.requestIssue(owner: "shingha1124", repo: "issue-tracker")
            }
            .share()
        
        let issueCellViewModels = requestIssueList
            .compactMap { $0.value }
            .map { $0.map { IssueTableViewCellModel(issue: $0) } }
            .share()
        
        issueCellViewModels
            .bind(to: state.issues)
            .disposed(by: disposeBag)
    }
}
