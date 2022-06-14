//
//  File.swift
//  issueTracker
//
//  Created by 이준우 on 2022/06/14.
//
import UIKit
import RxSwift

final class LabelListViewController: BaseViewController, View {

    private lazy var addButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.title = "추가 +"
        button.style = .plain
        return button
    }()
    
    var disposeBag = DisposeBag()
    
    func bind(to viewModel: LabelListViewModel) {
        //이벤트 발생
        viewModel.action.updateLabels.accept(())

        viewModel.state.updatedLabels
            .withUnretained(self)
            .bind(onNext: { _, labels in
                print(labels)
        self.addButton.rx.tap
            .withUnretained(self)
            .bind(onNext: { _ in
                self.viewModel?.pushInsertViewController()
            })
            .disposed(by: disposeBag)
    }
        
    override func attribute() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        title = "레이블"
        self.navigationItem.rightBarButtonItem = addButton
        view.backgroundColor = .systemGray6
    }
}
