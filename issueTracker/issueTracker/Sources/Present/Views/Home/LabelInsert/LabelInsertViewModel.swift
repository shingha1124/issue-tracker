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
        let viewDidLoad = PublishRelay<Void>()
        let dismissView = PublishRelay<Void>()
    }
    
    struct State {
        let updatedTitleValue = PublishRelay<String>()
        let updatedDescriptionValue = PublishRelay<String>()
        let updatedRgbValue = PublishRelay<String>()
    }
    
    let action = Action()
    let state = State()
    private let disposeBag = DisposeBag()
    private weak var navigation: LabelListNavigation?

    @Inject(\.gitHubRepository) private var gitHubRepository: GitHubRepository
    
    init(navigation: LabelListNavigation) {
        self.navigation = navigation
        
        //State 속성 초기값 지정
        setInitialStates()
        //Action 속성과 State 속성 바인딩
        bindActionsToStates()
        //State 속성과 라벨 생성 요청 바인딩
        bindStatesToCreatingRequest()
    }
    
    private func setInitialStates() {
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
        
        action.dismissView
            .withUnretained(self)
            .bind(onNext: { viewModel, _ in
                viewModel.navigation?.goBackToLabelList()
            })
            .disposed(by: disposeBag)
    }
    
    private func bindActionsToStates() {
        action.enteredTitleValue
            .bind(to: state.updatedTitleValue)
            .disposed(by: disposeBag)
        
        action.enteredDescriptionValue
            .bind(to: state.updatedDescriptionValue)
            .disposed(by: disposeBag)
    }
    
    private func bindStatesToCreatingRequest() {
        let parameters = Observable
            .combineLatest(state.updatedRgbValue, state.updatedDescriptionValue, state.updatedTitleValue) { color, description, title in
                ["name": title, "description": description, "color": String(color.dropFirst())]
            }
            .share()
        
        let requestCreatingLabel = action.tappedAddingLabelButton
            .withLatestFrom(parameters)
            .map { param in
                RequestCreatingLabelParameters(owner: Constants.owner, repo: Constants.repo, parameters: param)
            }
            .withUnretained(self)
            .flatMapLatest { viewModel, parameters in
                viewModel.gitHubRepository.requestCreatingLabel(parameters: parameters)
            }
            .share()
        
        requestCreatingLabel
            .compactMap { _ in }
            .bind(to: action.dismissView)
            .disposed(by: disposeBag)
        
        requestCreatingLabel
            .compactMap { $0.error }
            .bind(onNext: {
                Log.error("\($0)")
            })
            .disposed(by: disposeBag)
    }
}
