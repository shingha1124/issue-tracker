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
        let tappedMoreButton = PublishRelay<Void>()
        let requestComments = PublishRelay<Void>()
        let inputComment = PublishRelay<String>()
        let requestCreatingComment = PublishRelay<Void>()
    }
    
    struct State {
        let issue = PublishRelay<Issue>()
        let issueTitle = PublishRelay<String>()
        let issueState = PublishRelay<Issue.State>()
        let issueNumber = PublishRelay<Int>()
        let issueDate = PublishRelay<Date>()
        let comments = PublishRelay<[CommentTableViewCellModel]>()
    }
    
    let action = Action()
    let state = State()
    
    private let disposeBag = DisposeBag()
    private weak var coordinator: IssueListViewCoordinator?
    
    @Inject(\.gitHubRepository) private var githubRepository: GitHubRepository
    
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
        
        action.tappedMoreButton
            .map { issue }
            .bind(to: coordinator.present.issueDetailPopover)
            .disposed(by: disposeBag)
        
        let requestComments = action.requestComments
            .map {
                RequestUpdateIssueParameters(number: issue.number, parameters: nil)
            }
            .withUnretained(self)
            .flatMapLatest { viewModel, parameters in
                viewModel.githubRepository.requestIssueComments(parameters: parameters)
            }
            .share()
        
        requestComments
            .compactMap { $0.value }
            .map { $0.map { CommentTableViewCellModel(comment: $0) } }
            .bind(to: state.comments)
            .disposed(by: disposeBag)
        
        requestComments
            .compactMap { $0.error }
            .bind(onNext: {
                Log.error("\($0)")
            })
            .disposed(by: disposeBag)
        
        let requestCreatingComment = action.requestCreatingComment
            .withLatestFrom(action.inputComment)
            .map { RequestUpdateIssueParameters(number: issue.number, parameters: ["body": $0]) }
            .withUnretained(self)
            .flatMapLatest { viewModel, param in
                viewModel.githubRepository.requestCreatingComment(parameters: param)
            }
            .share()
        
        requestCreatingComment
            .compactMap { $0.value }
            .withUnretained(self)
            .bind(onNext: { viewModel, comment in
                Log.debug("\(comment)")
            })
            .disposed(by: disposeBag)
                
        requestCreatingComment
            .compactMap { $0.error }
            .bind(onNext: {
                Log.error("\($0.localizedDescription)\($0.statusCode)")
            })
            .disposed(by: disposeBag)
    }
}
