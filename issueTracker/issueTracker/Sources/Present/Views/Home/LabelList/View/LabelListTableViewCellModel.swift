//
//  LabelListTableViewCellModel.swift
//  issueTracker
//
//  Created by 이준우 on 2022/06/16.
//

import Foundation
import RxRelay
import RxSwift

final class LabelListTableViewCellModel: ViewModel {

    struct Action {
        let loadData = PublishRelay<Void>()
    }
    
    struct State {
        let label: Label
        let name = PublishRelay<String>()
        let description = PublishRelay<String?>()
        let color = PublishRelay<String>()
    }
    
    let action = Action()
    let state: State
    private let disposeBag = DisposeBag()
    
    init(label: Label) {
        state = State(label: label)
     
        action.loadData
            .map { label.name }
            .bind(to: state.name)
            .disposed(by: disposeBag)
        
        action.loadData
            .map { label.description }
            .bind(to: state.description)
            .disposed(by: disposeBag)
        
        action.loadData
            .map { label.color }
            .bind(to: state.color)
            .disposed(by: disposeBag)
    }
}
