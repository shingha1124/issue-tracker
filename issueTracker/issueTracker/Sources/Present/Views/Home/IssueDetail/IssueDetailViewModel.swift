//
//  IssueDetailViewModel.swift
//  issueTracker
//
//  Created by 이준우 on 2022/06/29.
//
import Foundation

final class IssueDetailViewModel: ViewModel {
    struct Action {}
    struct State {}
    
    let action = Action()
    let state = State()
    
    private weak var coordinator: IssueListViewCoordinator?

    init(coordinator: IssueListViewCoordinator) {
        self.coordinator = coordinator
    }
}
