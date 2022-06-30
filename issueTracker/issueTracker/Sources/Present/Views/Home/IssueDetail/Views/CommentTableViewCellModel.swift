//
//  IssueDetailtableViewCellModel.swift
//  issueTracker
//
//  Created by 이준우 on 2022/06/30.
//

import Foundation
import RxRelay
import RxSwift

final class CommentTableViewCellModel: ViewModel {
    
    struct Action {
        let loadData = PublishRelay<Void>()
        let requestAvatarImage = PublishRelay<URL>()
    }
    
    struct State {
        let body = PublishRelay<String>()
        let createdAt = PublishRelay<Date>()
        let user = PublishRelay<User>()
        let avatarImage = PublishRelay<Data>()
    }
    
    let action = Action()
    let state = State()
    private let disposeBag = DisposeBag()

    @Inject(\.gitHubRepository) private var githubRepository: GitHubRepository

    init(comment: Comment) {
      
        action.loadData
            .map { comment.body }
            .bind(to: state.body)
            .disposed(by: disposeBag)
        
        action.loadData
            .map { comment.createdAt }
            .bind(to: state.createdAt)
            .disposed(by: disposeBag)
        
        action.loadData
            .map { comment.user }
            .bind(to: state.user)
            .disposed(by: disposeBag)
        
        action.loadData
            .map { comment.user.avatarUrl }
            .bind(to: action.requestAvatarImage)
            .disposed(by: disposeBag)
        
        let requestImage = action.requestAvatarImage
            .withUnretained(self)
            .flatMapLatest { viewModel, url in
                viewModel.githubRepository.requestAvatarImage(url: url)
            }
            .share()
        
        requestImage
            .compactMap { $0.value }
            .bind(to: state.avatarImage)
            .disposed(by: disposeBag)
        
        requestImage
            .compactMap { $0.error }
            .bind(onNext: {
                Log.error("\($0.statusCode)")
            })
            .disposed(by: disposeBag)
    }
}
