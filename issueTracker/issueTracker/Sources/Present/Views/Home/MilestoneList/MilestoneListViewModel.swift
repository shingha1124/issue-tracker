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
    func goToMilestoneInsertion()
    func goBackToMilestoneList()
}

final class MilestoneListViewModel: ViewModel {    
    struct Action {
        let requestMilestones = PublishRelay<Void>()
        let milestoneInsertButtonTapped = PublishRelay<Void>()
    }
    struct State {
        let milestones = PublishRelay<[MilestoneTableViewCellModel]>()
    }
    
    let action = Action()
    let state = State()
    
    private let disposeBag = DisposeBag()
    private weak var coordinator: MileStoneViewCoordinator?
    
    @Inject(\.gitHubRepository) private var githubRepository: GitHubRepository
    
    init(coordinator: MileStoneViewCoordinator) {
        self.coordinator = coordinator
        
        let requestMilestones = action.requestMilestones
            .map {
                RequestRepositoryParameters(parameters: nil)
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
        
        action.milestoneInsertButtonTapped
            .bind(to: coordinator.goToMilestoneInsertion)
            .disposed(by: disposeBag)
    }
}
