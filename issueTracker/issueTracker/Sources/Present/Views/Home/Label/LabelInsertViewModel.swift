//
//  LabelInsertViewModel.swift
//  issueTracker
//
//  Created by 이준우 on 2022/06/15.
//
import Foundation
import RxSwift
import RxRelay

final class LabelInsertViewModel: ViewModel {
  
    private weak var navigation: LabelListNavigation?

    struct Action {
        let enteredTitleValue = PublishRelay<String>()
        let enteredDescriptionValue = PublishRelay<String>()
        let enteredRgbValue = PublishRelay<String>()
    }
    
    struct State {
        let updatedTitleValue = PublishRelay<String>()
        let updatedDescriptionValue = PublishRelay<String>()
        let updatedRgbValue = PublishRelay<String>()
    }
    
    let action = Action()
    let state = State()
    private let disposeBag = DisposeBag()
    
    init(navigation: LabelListNavigation) {
        self.navigation = navigation
        
        action.enteredTitleValue
            .bind(to: self.state.updatedTitleValue)
            .disposed(by: disposeBag)
        
        action.enteredDescriptionValue
            .bind(to: self.state.updatedDescriptionValue)
            .disposed(by: disposeBag)
        
        action.enteredRgbValue
            .bind(to: self.state.updatedRgbValue)
            .disposed(by: disposeBag)
    }
}