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

protocol LabelListNavigation: AnyObject {
    func goToLabelInsertion()
    func goBackToLabelList()
}

final class LabelListViewModel: ViewModel {
    
    private enum Constants {
        static let owner = "shingha1124"
        static let repo = "issue-tracker"
    }
    
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
    private weak var navigation: LabelListNavigation?
    
    @Inject(\.gitHubRepository) private var githubRepository: GitHubRepository
    
    init(navigation: LabelListNavigation) {
        self.navigation = navigation
        
        action.labelInsertButtonTapped
            .withUnretained(self)
            .bind(onNext: { viewModel, _ in
                viewModel.navigation?.goToLabelInsertion()
            })
            .disposed(by: disposeBag)
        
        let requestLabelList = action.labelListRequest
            .map {
                RequestLabelsParameters(owner: Constants.owner, repo: Constants.repo)
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
