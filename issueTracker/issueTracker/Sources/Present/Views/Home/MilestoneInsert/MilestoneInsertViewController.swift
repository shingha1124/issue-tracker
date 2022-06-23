//
//  MilestoneInsertViewController.swift
//  issueTracker
//
//  Created by 이준우 on 2022/06/21.
//
import RxCocoa
import RxSwift
import SnapKit
import UIKit

final class MilestoneInsertViewController: BaseViewController, View {
    
    private let cancelButton: UIBarButtonItem = {
       let button = UIBarButtonItem()
        button.title = "Cancel".localized()
        button.style = .done
        return button
    }()
    
    private let addButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.title = "Save".localized()
        button.style = .plain
        return button
    }()
    
    private let insertForm: MilestoneInsertForm = {
        let insertForm = MilestoneInsertForm()
        return insertForm
    }()
    
    var disposeBag = DisposeBag()
    
    func bind(to viewModel: MilestoneInsertViewModel) {
        
        addButton.rx.tap
            .bind(to: viewModel.action.addButtonTapped)
            .disposed(by: disposeBag)
        
        cancelButton.rx.tap
            .bind(to: viewModel.action.cancelButtonTapped)
            .disposed(by: disposeBag)
        
        insertForm.titleField.didChange
            .compactMap { $0 }
            .bind(to: viewModel.action.enteredTitleValue)
            .disposed(by: disposeBag)
        
        insertForm.descriptionField.didChange
            .compactMap { $0 }
            .bind(to: viewModel.action.enteredDescriptionValue)
            .disposed(by: disposeBag)
        
        insertForm.deadlineField.didChange
            .compactMap { $0 }
            .bind(to: viewModel.action.enteredDeadlineValue)
            .disposed(by: disposeBag)
    }
    
    override func attribute() {
        super.attribute()
        view.backgroundColor = .systemGray6
        navigationItem.title = "New Milestone".localized()
        navigationItem.rightBarButtonItem = addButton
        navigationItem.leftBarButtonItem = cancelButton
    }
    
    override func layout() {
        super.layout()
        
        view.addSubview(insertForm)
        insertForm.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.width.equalToSuperview()
        }
    }
}
