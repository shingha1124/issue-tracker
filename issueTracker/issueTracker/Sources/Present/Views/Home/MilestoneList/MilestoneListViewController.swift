//
//  MilestoneListViewController.swift
//  issueTracker
//
//  Created by 이준우 on 2022/06/20.
//

import RxCocoa
import RxRelay
import RxSwift
import UIKit

final class MilestoneListViewController: BaseViewController, View {
    
    private let addButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.title = "추가 +"
        button.style = .plain
        return button
    }()
    
    private let milestoneListTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorColor = .separator1
        tableView.register(MilestoneListTableViewCell.self,
                           forCellReuseIdentifier: MilestoneListTableViewCell.identifier)
        return tableView
    }()
    
    var disposeBag = DisposeBag()
    
    func bind(to viewModel: MilestoneListViewModel) {
        
        rx.viewDidLoad
            .bind(to: viewModel.action.requestMilestones)
            .disposed(by: disposeBag)
        
        rx.viewWillAppear
            .withUnretained(self)
            .bind(onNext: {vc, _ in
                vc.navigationController?.navigationBar.prefersLargeTitles = true
            })
            .disposed(by: disposeBag)
        
        viewModel.state.milestones
            .bind(to: milestoneListTableView.rx.items(cellIdentifier: MilestoneListTableViewCell.identifier, cellType: MilestoneListTableViewCell.self)) { _, viewModel, cell in

                cell.viewModel = viewModel
            }
            .disposed(by: disposeBag)
        
        addButton.rx.tap
            .bind(to: viewModel.action.milestoneInsertButtonTapped)
            .disposed(by: disposeBag)
    }
    
    override func attribute() {
        title = "마일스톤"
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = addButton
    }
    
    override func layout() {
        view.addSubview(milestoneListTableView)
        milestoneListTableView.snp.makeConstraints {
            $0.top.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
    }
}
