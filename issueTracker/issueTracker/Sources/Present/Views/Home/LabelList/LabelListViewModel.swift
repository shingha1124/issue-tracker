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
    
    /*
     - Repository 의존성을 사실상 필드 주입 방식으로 의존받고 있음
     - Testable한 뷰모델을 만드려면, 생성자 주입 방식을 적용하는 것이 어떨까 싶음
     - Mock인스턴스에 의존해야 하는 처리를 해야 하므로 결국 외부에서 의존성을 주입해줘야 할 것 같기 때문
     */
    @Inject(\.gitHubRepository) private var githubRepository: GitHubRepository
    
    init(navigation: LabelListNavigation) {
        self.navigation = navigation
        
        //화면에서 추가버튼 눌렀을 때, 다음 버튼으로 넘어가는 동작 바인딩
        action.labelInsertButtonTapped
            .withUnretained(self)
            .bind(onNext: { viewModel, _ in
                viewModel.navigation?.goToLabelInsertion()
            })
            .disposed(by: disposeBag)
        
       /*
            - 깃허브 API 받아서 state.updatedLabels에 응답받은 라벨 리스트 바인딩
            - state.updatedLabels는 뷰컨트롤러의 테이블뷰 속성에 쓰이는 테이블뷰 셀에 바인딩됨
        */
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
            })
            .disposed(by: disposeBag)
    }
}
