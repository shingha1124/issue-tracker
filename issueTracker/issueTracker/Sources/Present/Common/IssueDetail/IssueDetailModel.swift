//
//  SheetViewModel.swift
//  issueTracker
//
//  Created by seongha shin on 2022/06/30.
//

import Foundation
import RxRelay
import RxSwift

final class IssueDetailModel: ViewModel {
    struct Action {
        let viewDidLoad = PublishRelay<Void>()
    }
    
    struct State {
        let items = PublishRelay<[IssueDetailInfo]>()
    }
    
    let action = Action()
    let state = State()
    let disposeBag = DisposeBag()
    
    init(issue: Issue) {
        action.viewDidLoad
            .map { _ in
                [
                    IssueDetailInfo(type: .labels, iconName: nil, description: issue.labels?.map { "\($0.name)" }.joined(separator: ", ")),
                    IssueDetailInfo(type: .milestone, iconName: nil, description: issue.milestone?.title),
                    IssueDetailInfo(type: .issueEdit, iconName: "pencil", description: nil),
                    IssueDetailInfo(type: .issueEdit, iconName: "archivebox", description: nil)
                ]
            }
            .bind(to: state.items)
            .disposed(by: disposeBag)
    }
}

struct IssueDetailInfo {
    let type: IssueDetailType
    let iconName: String?
    let description: String?
}

enum IssueDetailType {
    case labels
    case milestone
    case issueEdit
    case issueClose
}
