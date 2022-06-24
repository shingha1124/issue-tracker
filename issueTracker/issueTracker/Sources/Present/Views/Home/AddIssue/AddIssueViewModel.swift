//
//  AddIssueViewModel.swift
//  issueTracker
//
//  Created by seongha shin on 2022/06/24.
//

import Foundation
import RxSwift
import RxRelay

final class AddIssueViewModel: ViewModel {
    struct Action {
        let viewDidLoad = PublishRelay<Void>()
        let selectAlertItem = PublishRelay<(AdditionalType, Int)>()
    }
    
    struct State {
        let additionalInfoViewModels = PublishRelay<[AdditionalInfoItemViewModel]>()
        let presentAlert = PublishRelay<(AdditionalType, [String])>()
    }
    
    let action = Action()
    let state = State()
    let disposeBag = DisposeBag()
    private var additionalModels = [AdditionalType: AdditionalInfoItemViewModel]()
    private var additionalData = [AdditionalType: [String]]()
    
    @Inject(\.gitHubRepository) private var gitHubRepository: GitHubRepository
    
    
    init(coordinator: IssueListViewCoordinator) {
        
        let requestLabels = action.viewDidLoad
            .map {
                RequestRepositoryParameters(parameters: nil)
            }
            .withUnretained(self)
            .flatMapLatest { model, param in
                model.gitHubRepository.requestLabels(parameters: param)
            }
            .share()
        
        requestLabels
            .compactMap { $0.value }
            .withUnretained(self)
            .bind(onNext: { model, labels in
                model.additionalData[.labels] = labels.map { $0.name }
            })
            .disposed(by: disposeBag)
        
        let requestMilestone = action.viewDidLoad
            .map {
                RequestRepositoryParameters(parameters: nil)
            }
            .withUnretained(self)
            .flatMapLatest { model, param in
                model.gitHubRepository.requestMilestones(parameters: param)
            }
            .share()
        
        requestMilestone
            .compactMap { $0.value }
            .withUnretained(self)
            .bind(onNext: { model, milestone in
                model.additionalData[.milestone] = milestone.map { $0.title }
            })
            .disposed(by: disposeBag)
        
        let requestAssignees = action.viewDidLoad
            .map {
                RequestRepositoryParameters(parameters: nil)
            }
            .withUnretained(self)
            .flatMapLatest { model, param in
                model.gitHubRepository.requestAssignees(parameters: param)
            }
            .share()
        
        requestAssignees
            .compactMap { $0.value }
            .withUnretained(self)
            .bind(onNext: { model, assignees in
                model.additionalData[.assignees] = assignees.map { $0.login }
            })
            .disposed(by: disposeBag)
        
        let viewModels = action.viewDidLoad
            .map {
                AdditionalType.allCases.map { ($0, AdditionalInfoItemViewModel(type: $0)) }
            }
            .share()
        
        viewModels
            .map { $0.map { $0.1 } }
            .bind(to: state.additionalInfoViewModels)
            .disposed(by: disposeBag)
        
        viewModels
            .map { $0.reduce(into: [AdditionalType: AdditionalInfoItemViewModel]()){
                $0[$1.0] = $1.1
            } }
            .withUnretained(self)
            .bind(onNext: { model, additionalDataModels in
                model.additionalModels = additionalDataModels
            })
            .disposed(by: disposeBag)
        
        let tappedItems = viewModels
            .map { $0.map { $0.1 } }
            .flatMapLatest { models -> Observable<AdditionalType> in
                let tappedItems = models.map { model -> Observable<AdditionalType> in
                    model.action.tappedItemType.asObservable()
                }
                return .merge(tappedItems)
            }
        
        tappedItems
            .withUnretained(self)
            .compactMap { model, type -> (AdditionalType, [String])? in
                guard let titles = model.additionalData[type] else {
                    return nil
                }
                return (type, titles)
            }
            .bind(to: state.presentAlert)
            .disposed(by: disposeBag)
        
        action.selectAlertItem
            .withUnretained(self)
            .compactMap { model, select -> (AdditionalInfoItemViewModel, String)? in
                let (type, index) = select
                guard let itemModel = model.additionalModels[type],
                    let selectData = model.additionalData[type]?[index] else {
                    return nil
                }
                return (itemModel, selectData)
            }
            .bind(onNext: { itemModel, target in
                itemModel.state.target.accept(target)
            })
            .disposed(by: disposeBag)
    }
}


enum AdditionalType: CaseIterable {
    case labels
    case milestone
    case assignees
    
    var title: String {
        switch self {
        case .labels:
            return "Labels".localized()
        case .milestone:
            return "Milestone".localized()
        case .assignees:
            return "Assignees".localized()
        }
    }
}
