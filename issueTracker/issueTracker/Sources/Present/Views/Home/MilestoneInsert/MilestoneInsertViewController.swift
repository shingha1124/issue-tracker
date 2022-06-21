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
        button.title = "취소"
        button.style = .done
        return button
    }()
    
    private let addButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.title = "저장"
        button.style = .plain
        return button
    }()
    
    private let insertForm: MilestoneInsertForm = {
        let insertForm = MilestoneInsertForm()
        return insertForm
    }()
    
    var disposeBag = DisposeBag()
    
    func bind(to viewModel: MilestoneInsertViewModel) {
    }
    
    override func attribute() {
        super.attribute()
        view.backgroundColor = .systemGray6
        navigationItem.title = "새로운 마일스톤"
        navigationItem.rightBarButtonItem = addButton
        navigationItem.leftBarButtonItem = cancelButton
    }
    
    override func layout() {
        super.layout()
        
        view.addSubview(insertForm)
        insertForm.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(20)
            $0.width.equalToSuperview()
        }
    }
}
