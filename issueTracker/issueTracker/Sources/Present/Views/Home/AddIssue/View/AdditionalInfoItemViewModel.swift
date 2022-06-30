//
//  AdditionalInfoItemViewModel.swift
//  issueTracker
//
//  Created by seongha shin on 2022/06/24.
//

import Foundation
import RxRelay
import RxSwift

final class AdditionalInfoItemViewModel: ViewModel {
    struct Action {
        let loadData = PublishRelay<Void>()
        let tappedItem = PublishRelay<Void>()
        let tappedItemType = PublishRelay<AdditionalType>()
    }
    
    struct State {
        let title = PublishRelay<String>()
        let target = PublishRelay<String>()
    }
    
    let action = Action()
    let state = State()
    let disposeBag = DisposeBag()
    
    init(type: AdditionalType) {
        action.loadData
            .map { type.title }
            .bind(to: state.title)
            .disposed(by: disposeBag)
        
        action.tappedItem
            .map { type }
            .bind(to: action.tappedItemType)
            .disposed(by: disposeBag)            
    }
}
