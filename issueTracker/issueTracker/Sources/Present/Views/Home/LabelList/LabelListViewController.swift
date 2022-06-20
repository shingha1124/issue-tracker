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
        tableView.separatorColor = .separator1
        tableView.register(LabelListTableViewCell.self,
                           forCellReuseIdentifier: LabelListTableViewCell.identifier)
        return tableView
    }()
    
    var disposeBag = DisposeBag()
    
    func bind(to viewModel: LabelListViewModel) {
        
        rx.viewDidLoad
            .bind(to: viewModel.action.labelListRequest)
            .disposed(by: disposeBag)
        
        viewModel.state.labels
            .bind(to: labelListTableView.rx.items(cellIdentifier: LabelListTableViewCell.identifier,
                                                  cellType: LabelListTableViewCell.self)) { _, viewModel, cell in
                cell.viewModel = viewModel
            }
            .disposed(by: disposeBag)
        
        addButton.rx.tap
            .bind(to: viewModel.action.labelInsertButtonTapped)
            .disposed(by: disposeBag)
        
        rx.viewWillAppear
            .withUnretained(self)
            .bind(onNext: { vc, _ in
                vc.navigationController?.navigationBar.prefersLargeTitles = true
            })
            .disposed(by: disposeBag)
        
        rx.viewWillDisappear
            .withUnretained(self)
            .bind(onNext: { vc, _ in
                vc.navigationController?.navigationBar.prefersLargeTitles = false
            })
            .disposed(by: disposeBag)
    }
    
    override func attribute() {
        title = "레이블"
        navigationItem.rightBarButtonItem = addButton
        view.backgroundColor = .white
    }
    
    override func layout() {
        view.addSubview(labelListTableView)
        labelListTableView.snp.makeConstraints {
            $0.top.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
    }
}
