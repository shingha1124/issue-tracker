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

struct LabelInfo {
    let labelName: String
    let labelDescription: String
    let labelColor: String
}

protocol LabelListNavigation: AnyObject {
    func goToLabelList()
    func goToLabelInsertion()
}

final class LabelListViewModel: ViewModel {

    private weak var navigation: LabelListNavigation?

    struct Action {
        let updateLabels = PublishRelay<Void>()
        let labelInsertTap = PublishRelay<Void>()
    }
    
    struct State {
        let updatedLabels = PublishRelay<[LabelInfo]>()
    }
    
    private let disposeBag = DisposeBag()
    let action = Action()
    let state = State()
    
    init(navigation: LabelListNavigation) {
        self.navigation = navigation
        self.loadTemporaryData()
    }
    
    private func loadTemporaryData() {
        var labelList: [LabelInfo] = []
        for num in 1...10 {
            let title = "label\(num)"
            let description = "description for label\(num)"
            let color = "#FFFFFF"
            let labelInfo = LabelInfo(labelName: title, labelDescription: description, labelColor: color)
            
            labelList.append(labelInfo)
        }
        
        self.action.updateLabels
            .withUnretained(self)
            .bind(onNext: { _ in
                print(labelList)
                self.state.updatedLabels.accept(labelList)
            })
            .disposed(by: disposeBag)
    }
}