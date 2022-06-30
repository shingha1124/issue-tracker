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
    }
    
    let action = Action()
    let state = State()
    private let disposeBag = DisposeBag()

    init(comment: Comment) {
      
        action.loadData
            .map { comment.body }
            .bind(to: state.body)
            .disposed(by: disposeBag)
        
        action.loadData
            .map { comment.createdAt }
            .bind(to: state.createdAt)
            .disposed(by: disposeBag)
    }
}
