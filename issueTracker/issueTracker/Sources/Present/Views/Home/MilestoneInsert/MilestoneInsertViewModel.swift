//
//  MilestoneInsertViewModel.swift
//  issueTracker
//
//  Created by 이준우 on 2022/06/21.
//

import Foundation
import RxRelay
import RxSwift

final class MilestoneInsertViewModel: ViewModel {
    private enum Constants {
        static let owner = "shingha1124"
        static let repo = "issue-tracker"
    }
    
    struct Action {
        let cancelButtonTapped = PublishRelay<Void>()
        let addButtonTapped = PublishRelay<Void>()
        let enteredTitleValue = PublishRelay<String>()
        let enteredDescriptionValue = PublishRelay<String>()
        let enteredDeadlineValue = PublishRelay<String>()
    }
    
    struct State {
        let updatedTitleValue = PublishRelay<String>()
        let updatedDescriptionValue = PublishRelay<String>()
        let updatedDeadlineValue = PublishRelay<String>()
    }
    
    let action = Action()
    let state = State()
    private let disposeBag = DisposeBag()
    private weak var navigation: MilestoneListNavigation?
    
    @Inject(\.gitHubRepository) private var gitHubRepository: GitHubRepository
    
    init(navigation: MilestoneListNavigation) {
        self.navigation = navigation
        
        action.cancelButtonTapped
            .withUnretained(self)
            .bind(onNext: { viewModel, _ in
                viewModel.navigation?.goBackToMilestoneList()
            })
            .disposed(by: disposeBag)
        
        action.enteredTitleValue
            .bind(to: state.updatedTitleValue)
            .disposed(by: disposeBag)
        
        action.enteredDescriptionValue
            .bind(to: state.updatedDescriptionValue)
            .disposed(by: disposeBag)
        
        action.enteredDeadlineValue
            .bind(to: state.updatedDeadlineValue)
            .disposed(by: disposeBag)
        
        let parameters = Observable
            .combineLatest(
                state.updatedTitleValue.compactMap { $0 },
                state.updatedDescriptionValue,
                state.updatedDeadlineValue.map { $0.toDate(format: "yyyy-MM-dd")?.ISO8601Format() ?? "" }
            )
            .map { title, description, deadline in
                ["title": title, "description": description, "due_on": "\(deadline)"]
            }
            .share()
        
        let requestCreatingMilestone = action.addButtonTapped
            .withLatestFrom(parameters)
            .map { param in
                RequestCreatingMilestoneParameters(owner: Constants.owner, repo: Constants.repo, parameters: param)
            }
            .withUnretained(self)
            .flatMapLatest { viewModel, parameters in
                viewModel.gitHubRepository.requestCreatingMilestone(parameters: parameters)
            }
            .share()

        requestCreatingMilestone
            .compactMap { _ in }
            .withUnretained(self)
            .bind(onNext: { viewModel, _ in
                viewModel.navigation?.goBackToMilestoneList()
            })
            .disposed(by: disposeBag)

        requestCreatingMilestone
            .compactMap { $0.error }
            .bind(onNext: {
                Log.error("\($0)")
            })
            .disposed(by: disposeBag)
    }
}
