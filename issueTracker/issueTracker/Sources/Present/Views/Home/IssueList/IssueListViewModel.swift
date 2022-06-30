//
//  IssueListViewModel.swift
//  issueTracker
//
//  Created by seongha shin on 2022/06/13.
//

import Foundation
import RxRelay
import RxSwift

final class IssueListViewModel: ViewModel {
    struct Action {
        let requestIssue = PublishRelay<Void>()
        let closeIssue = PublishRelay<Int>()
        let tappedAddissue = PublishRelay<Void>()
    }
    
    struct State {
        let issues = PublishRelay<[IssueTableViewCellModel]>()
        let enableLoadingIndactorView = PublishRelay<Bool>()
    }
    
    let action = Action()
    let state = State()
    
    private let disposeBag = DisposeBag()
    private weak var coordinator: IssueListViewCoordinator?
    @Inject(\.gitHubRepository) private var gitHubRepository: GitHubRepository
    @Inject(\.coreDataRepository) private var coreDataRepository: CoreDataRepository
    
    init(coordinator: IssueListViewCoordinator) {
        self.coordinator = coordinator
        
        let requestIssueList = action.requestIssue
            .map {
                RequestRepositoryParameters(parameters: nil)
            }
            .do(onNext: { [weak self] _ in
                self?.state.enableLoadingIndactorView.accept(true)
            })
            .withUnretained(self)
            .flatMapLatest { model, param in
                model.gitHubRepository.requestRepoIssueList(parameters: param)
            }
            .do(onNext: { [weak self] _ in
                self?.state.enableLoadingIndactorView.accept(false)
            })
            .share()
        
        let issueCellViewModels = requestIssueList
            .compactMap { $0.value }
            .withUnretained(self)
            .map { vm, value in
                vm.coreDataRepository.fetch(CDInssue.self, values: value)
            }
            .map { $0.filter { $0.state != .closed } }
            .map { $0.map { IssueTableViewCellModel(issue: $0) } }
            .share()
        
        issueCellViewModels
            .bind(to: state.issues)
            .disposed(by: disposeBag)
        
        let requestIssueClose = action.closeIssue
            .withLatestFrom(state.issues) { index, viewModels in
                viewModels[index].state.issue.number
            }
            .map {
                RequestUpdateIssueParameters(number: $0, parameters: ["state": Issue.State.closed.value])
            }
            .do(onNext: { [weak self] _ in
                self?.state.enableLoadingIndactorView.accept(true)
            })
            .withUnretained(self)
            .flatMapLatest { model, param in
                model.gitHubRepository.requestUpdateIssue(parameters: param)
            }
            .do(onNext: { [weak self] _ in
                self?.state.enableLoadingIndactorView.accept(false)
            })
            .share()

        requestIssueClose
            .compactMap { $0.value }
            .withUnretained(self)
            .do { vm, value in
                vm.coreDataRepository.update(CDInssue.self, value: value)
            }
            .map { _ in }
            .bind(to: action.requestIssue)
            .disposed(by: disposeBag)
        
        action.tappedAddissue
            .bind(to: coordinator.present.addIssue)
            .disposed(by: disposeBag)
    }
}
