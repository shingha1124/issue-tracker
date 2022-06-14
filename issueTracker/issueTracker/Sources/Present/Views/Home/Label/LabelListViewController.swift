//
//  File.swift
//  issueTracker
//
//  Created by 이준우 on 2022/06/14.
//
import UIKit
import RxSwift
import RxRelay

final class LabelListViewController: BaseViewController, View {
    
    private let addButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.title = "추가 +"
        button.style = .plain
        return button
    }()
    
    private let labelListDataSource = LabelListDataSource()
    private let labelListTableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.register(LabelListTableViewCell.self, forCellReuseIdentifier: LabelListTableViewCell.identifier)
        return tableView
    }()
    
    var disposeBag = DisposeBag()
    
    func bind(to viewModel: LabelListViewModel) {
        
        //이벤트 발생
        rx.viewDidLoad
            .withUnretained(self)
            .bind(onNext: { _ in
                viewModel.action.enteredLabels.accept(())
            })
            .disposed(by: disposeBag)
        
        viewModel.state.updatedLabels
            .withUnretained(self)
            .bind(onNext: { _, labels in
                self.labelListDataSource.updateLabelList(labels: labels)
                self.labelListTableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        addButton.rx.tap
            .withUnretained(self)
            .bind(onNext: { _ in
                self.viewModel?.action.labelInsertButtonTapped
                    .accept(())
            })
            .disposed(by: disposeBag)
    }
    
    override func attribute() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.title = "레이블"
        self.navigationItem.rightBarButtonItem = addButton
        self.view.backgroundColor = .systemGray6
        
        self.labelListTableView.dataSource = self.labelListDataSource
    }
    
    override func layout() {
        self.view.addSubview(labelListTableView)
        labelListTableView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
}
