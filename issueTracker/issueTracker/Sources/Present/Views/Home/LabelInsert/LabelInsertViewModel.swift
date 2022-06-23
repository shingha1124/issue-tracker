//
//  LabelInsertViewModel.swift
//  issueTracker
//
//  Created by 이준우 on 2022/06/15.
//
import Foundation
import RxRelay
import RxSwift

final class LabelInsertViewModel: ViewModel {
    private enum Constants {
        static let owner = "shingha1124"
        static let repo = "issue-tracker"
    }
    
    struct Action {
        let enteredTitleValue = PublishRelay<String>()
        let enteredDescriptionValue = PublishRelay<String>()
        let tappedColorChangeButton = PublishRelay<Void>()
        let tappedAddingLabelButton = PublishRelay<Void>()
        let tappedCancelButton = PublishRelay<Void>()
        let viewDidLoad = PublishRelay<Void>()
    }
    
    struct State {
        let updatedTitleValue = PublishRelay<String>()
        let updatedDescriptionValue = PublishRelay<String>()
        let updatedRgbValue = PublishRelay<String>()
    }
    
    let action = Action()
    let state = State()
    private let disposeBag = DisposeBag()
    private weak var coordinator: LabelListViewCoordinator?

    @Inject(\.gitHubRepository) private var gitHubRepository: GitHubRepository
    
    init(coordinator: LabelListViewCoordinator) {
        self.coordinator = coordinator
        
        action.viewDidLoad
            .map { "" }
            .bind(to: state.updatedTitleValue)
            .disposed(by: disposeBag)

        Observable
            .merge(action.viewDidLoad.asObservable(), action.tappedColorChangeButton.asObservable())
            .map { (0..<3).map { _ in String(format: "%02X", Int.random(in: 0...255)) }.joined() }
            .bind(to: state.updatedRgbValue)
            .disposed(by: disposeBag)
        
        action.viewDidLoad
            .map { "" }
            .bind(to: state.updatedDescriptionValue)
            .disposed(by: disposeBag)
        
        action.enteredTitleValue
            .bind(to: state.updatedTitleValue)
            .disposed(by: disposeBag)
        
        action.enteredDescriptionValue
            .bind(to: state.updatedDescriptionValue)
            .disposed(by: disposeBag)
        
        action.tappedCancelButton
            .bind(to: coordinator.dismiss)
            .disposed(by: disposeBag)
        
        let parameters = Observable
            .combineLatest(state.updatedRgbValue, state.updatedDescriptionValue, state.updatedTitleValue) { color, description, title in
                ["name": title, "description": description, "color": String(color.dropFirst())]
            }
            .share()
        
        let requestCreatingLabel = action.tappedAddingLabelButton
            .withLatestFrom(parameters)
            .map { param in
                RequestRepositoryParameters(parameters: param)
            }
            .withUnretained(self)
            .flatMapLatest { viewModel, parameters in
                viewModel.gitHubRepository.requestCreatingLabel(parameters: parameters)
            }
            .share()
        
        requestCreatingLabel
            .compactMap { _ in }
            .bind(to: coordinator.dismiss)
            .disposed(by: disposeBag)
        
        requestCreatingLabel
            .compactMap { $0.error }
            .bind(onNext: {
                Log.error("\($0)")
            })
            .disposed(by: disposeBag)
    }
}
