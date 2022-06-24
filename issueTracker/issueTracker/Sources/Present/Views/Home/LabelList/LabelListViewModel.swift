//
//  LabelViewModel.swift
//  issueTracker
//
//  Created by 이준우 on 2022/06/14.
//
import Foundation
import RxCocoa
import RxRelay
import RxSwift

final class LabelListViewModel: ViewModel {
    struct Action {
        let labelInsertButtonTapped = PublishRelay<Void>()
        let labelListRequest = PublishRelay<Void>()
    }
    
    struct State {
        let labels = PublishRelay<[LabelListTableViewCellModel]>()
    }
    
    let action = Action()
    let state = State()
    
    private let disposeBag = DisposeBag()
    private weak var coordinator: LabelListViewCoordinator?
    
    @Inject(\.gitHubRepository) private var githubRepository: GitHubRepository
    
    init(coordinator: LabelListViewCoordinator) {
        self.coordinator = coordinator
        
        action.labelInsertButtonTapped
            .bind(to: coordinator.goToLabelInserticon)
            .disposed(by: disposeBag)
        
        let requestLabelList = action.labelListRequest
            .map {
                RequestRepositoryParameters(parameters: nil)
            }
            .withUnretained(self)
            .flatMapLatest { viewModel, parameters in
                viewModel.githubRepository.requestLabels(parameters: parameters)
            }
            .share()
        
        requestLabelList
            .compactMap { $0.value }
            .map { $0.map { LabelListTableViewCellModel(label: $0) } }
            .bind(to: state.labels)
            .disposed(by: disposeBag)
        
        requestLabelList
            .compactMap { $0.error }
            .bind(onNext: {
                //TODO: error 처리
                Log.error("\($0)")
            })
            .disposed(by: disposeBag)
    }
}
