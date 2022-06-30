//
//  SheetViewModel.swift
//  issueTracker
//
//  Created by seongha shin on 2022/06/30.
//

import Foundation
import RxRelay
import RxSwift

final class IssueDetailPopoverViewModel: ViewModel {
    struct Action {
        let viewDidLoad = PublishRelay<Void>()
    }
    
    struct State {
        let models = PublishRelay<[IssueDetailPopoverItemViewModel]>()
    }
    
    let action = Action()
    let state = State()
    let disposeBag = DisposeBag()
    
    init(issue: Issue) {
        action.viewDidLoad
            .map { _ in
                [
                    IssueDetailInfo(type: .labels, iconName: nil, description: issue.labels?.map { "\($0.name)" }.joined(separator: ", ")),
                    IssueDetailInfo(type: .milestone, iconName: nil, description: issue.milestone == nil ? "" : issue.milestone?.title),
                    IssueDetailInfo(type: .editIssue, iconName: "pencil", description: nil),
                    IssueDetailInfo(type: .closeIssue, iconName: "archivebox", description: nil)
                ]
            }
            .map { $0.map { IssueDetailPopoverItemViewModel(itemInfo: $0) } }
            .bind(to: state.models)
            .disposed(by: disposeBag)
    }
}
enum IssueDetailType {
    case labels
    case milestone
    case editIssue
    case closeIssue
    
    var title: String {
        switch self {
        case .labels: return "Labels".localized()
        case .milestone: return "Milestone".localized()
        case .editIssue: return "Edit Issue".localized()
        case .closeIssue: return "Close Issue".localized()
        }
    }
}
