//
//  AddIssueViewModel.swift
//  issueTracker
//
//  Created by seongha shin on 2022/06/24.
//

import Foundation
import RxSwift
import RxRelay

final class AddIssueViewModel: ViewModel {
    struct Action {
        let viewDidLoad = PublishRelay<Void>()
    }
    
    struct State {
        let additionalInfoViewModels = PublishRelay<[AdditionalInfoItemViewModel]>()
    }
    
    let action = Action()
    let state = State()
    let disposeBag = DisposeBag()
    
    init(coordinator: IssueListViewCoordinator) {
        let viewModels = action.viewDidLoad
            .map {
                AdditionalType.allCases.map { AdditionalInfoItemViewModel(type: $0) }
            }
            .share()
        
        viewModels
            .bind(to: state.additionalInfoViewModels)
            .disposed(by: disposeBag)
        
        let tappedItems = viewModels
            .flatMapLatest { models -> Observable<AdditionalType> in
                let tappedItems = models.map { model -> Observable<AdditionalType> in
                    model.action.tappedItemType.asObservable()
                }
                return .merge(tappedItems)
            }
        
        tappedItems
            .bind(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
    }
}


enum AdditionalType: CaseIterable {
    case labels
    case milestone
    case assignees
    
    var title: String {
        switch self {
        case .labels:
            return "Labels".localized()
        case .milestone:
            return "Milestone".localized()
        case .assignees:
            return "Assignees".localized()
        }
    }
}
