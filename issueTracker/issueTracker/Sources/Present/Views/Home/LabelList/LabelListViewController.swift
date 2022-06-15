//
//  File.swift
//  issueTracker
//
//  Created by 이준우 on 2022/06/14.
//
import RxCocoa
import RxRelay
import RxSwift
import UIKit

final class LabelListViewController: BaseViewController, View {
    
    private let addButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.title = "추가 +"
        button.style = .plain
        return button
    }()
    
    private let labelListTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.register(LabelListTableViewCell.self,
                           forCellReuseIdentifier: LabelListTableViewCell.identifier)
        return tableView
    }()
    
    var disposeBag = DisposeBag()
    
    func bind(to viewModel: LabelListViewModel) {
        
        rx.viewDidLoad
            .bind(to: viewModel.action.enteredLabels)
            .disposed(by: disposeBag)
        
        viewModel.state.updatedLabels
            .bind(to: labelListTableView.rx.items(cellIdentifier: LabelListTableViewCell.identifier,
                                                  cellType: LabelListTableViewCell.self)) { _, model, cell in
                cell.updateValues(labelName: model.name,
                                  description: "description for \(model.name)",
                                  color: model.color)
            }
            .disposed(by: disposeBag)
        
        addButton.rx.tap
            .bind(to: viewModel.action.labelInsertButtonTapped)
            .disposed(by: disposeBag)
    }
    
    override func attribute() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.title = "레이블"
        self.navigationItem.rightBarButtonItem = addButton
        self.view.backgroundColor = .white
    }
    
    override func layout() {
        self.view.addSubview(labelListTableView)
        labelListTableView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
}
