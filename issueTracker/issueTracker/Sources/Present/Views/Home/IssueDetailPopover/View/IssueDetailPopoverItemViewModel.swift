//
//  IssueDetailPopoverItemViewModel.swift
//  issueTracker
//
//  Created by seongha shin on 2022/06/30.
//

import Foundation
import RxRelay
import RxSwift

final class IssueDetailPopoverItemViewModel: ViewModel {
    struct Action {
        let loadInfo = PublishRelay<Void>()
    }
    
    struct State {
        let title = PublishRelay<String>()
        let description = PublishRelay<String?>()
        let icon = PublishRelay<String?>()
    }
    
    let action = Action()
    let state = State()
    let disposeBag = DisposeBag()
    
    init(itemInfo: IssueDetailInfo) {
        action.loadInfo
            .map { itemInfo.type.title }
            .bind(to: state.title)
            .disposed(by: disposeBag)
        
        action.loadInfo
            .map { _ -> String? in
                guard let description = itemInfo.description else {
                    return nil
                }
                
                return description.isEmpty ? "없음" : description
            }
            .bind(to: state.description)
            .disposed(by: disposeBag)
        
        action.loadInfo
            .map { _ -> String? in
                if itemInfo.type == .closeIssue || itemInfo.type == .editIssue {
                    return itemInfo.iconName
                }
                return nil
            }
            .bind(to: state.icon)
            .disposed(by: disposeBag)
    }
}

struct IssueDetailInfo {
    let type: IssueDetailType
    let iconName: String?
    let description: String?
}
