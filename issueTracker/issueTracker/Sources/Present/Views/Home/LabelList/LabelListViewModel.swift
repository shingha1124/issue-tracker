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
    func goToLabelList()
    func goToLabelInsertion()
}

final class LabelListViewModel: ViewModel {

    private weak var navigation: LabelListNavigation?

    struct Action {
        let enteredLabels = PublishRelay<Void>()
        let labelInsertButtonTapped = PublishRelay<Void>()
    }
    
    struct State {
        let updatedLabels = PublishRelay<[Label]>()
    }
    
    private let disposeBag = DisposeBag()
    let action = Action()
    let state = State()
    
    init(navigation: LabelListNavigation) {
        self.navigation = navigation
        let labelList = self.loadTemporaryData()
        
        self.action.labelInsertButtonTapped
            .withUnretained(self)
            .bind(onNext: { _ in
                self.navigation?.goToLabelInsertion()
            })
            .disposed(by: disposeBag)
        
        self.action.enteredLabels
            .map { labelList }
            .bind(to: state.updatedLabels)
            .disposed(by: disposeBag)
    }
    
    private func loadTemporaryData() -> [Label] {
        var labelList: [Label] = []
        for num in 1...10 {
            let title = "label\(num)"
            let label = Label(name: title, description: "", color: "ff00ff")
            labelList.append(label)
        }
        return labelList
    }
}
