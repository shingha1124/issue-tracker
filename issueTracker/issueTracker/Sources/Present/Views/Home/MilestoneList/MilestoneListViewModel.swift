//
//  MilestoneListViewModel.swift
//  issueTracker
//
//  Created by 이준우 on 2022/06/20.
//

import Foundation
import RxCocoa
import RxRelay
import RxSwift

protocol MilestoneListNavigation: AnyObject {
    
}

final class MilestoneListViewModel: ViewModel {
    
    private enum Constants {
        static let owner = "shingha1124"
        static let repo = "issue-tracker"
    }
    
    struct Action {
        let requestMilestones = PublishRelay<Void>()
    }
    struct State {
        let milestones = PublishRelay<[MilestoneTableViewCellModel]>()
    }
    
    let action = Action()
    let state = State()
    
    private let disposeBag = DisposeBag()
    private weak var navigation: MilestoneListNavigation?
    
    @Inject(\.gitHubRepository) private var githubRepository: GitHubRepository
    
    init(navigation: MilestoneListNavigation) {
        self.navigation = navigation
        
        let requestMilestones = action.requestMilestones
            .map {
                RequestMilestoneParameters(owner: Constants.owner, repo: Constants.repo)
            }
            .withUnretained(self)
            .flatMapLatest { viewModel, parameters in
                viewModel.githubRepository.requestMilestones(parameters: parameters)
            }
            .share()
        
        requestMilestones
            .compactMap { $0.value }
            .map { $0.map { MilestoneTableViewCellModel(milestone: $0) } }
            .bind(to: state.milestones)
            .disposed(by: disposeBag)
        
        requestMilestones
            .compactMap { $0.error }
            .bind(onNext: {
                Log.error("\($0)")
            })
            .disposed(by: disposeBag)
    }
}
