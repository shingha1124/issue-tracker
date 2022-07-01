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
    }
    
    struct State {
        let body = PublishRelay<String>()
        let createdAt = PublishRelay<Date>()
        let loginId = PublishRelay<String>()
        let avatarImageUrl = PublishRelay<URL>()
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
            .compactMap { comment.createdAt }
            .bind(to: state.createdAt)
            .disposed(by: disposeBag)
        
        action.loadData
            .compactMap { comment.user?.login }
            .bind(to: state.loginId)
            .disposed(by: disposeBag)
        
        action.loadData
            .compactMap { comment.user?.avatarUrl }
            .bind(to: state.avatarImageUrl)
            .disposed(by: disposeBag)
    }
}
