//
//  IssueListViewController.swift
//  issueTracker
//
//  Created by seongha shin on 2022/06/13.
//

import RxSwift
import UIKit

final class IssueListViewController: BaseViewController, View {
    
    private let issueTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(IssueTableViewCell.self, forCellReuseIdentifier: IssueTableViewCell.identifier)
        return tableView
    }()
    
    var disposeBag = DisposeBag()
    
    func bind(to viewModel: IssueListViewModel) {
        rx.viewDidLoad
            .bind(to: viewModel.action.requestIssue)
            .disposed(by: disposeBag)
        
        rx.viewDidAppear
            .withUnretained(self)
            .bind(onNext: { vc, _ in
                vc.navigationController?.navigationBar.prefersLargeTitles = true
            })
            .disposed(by: disposeBag)
        
        viewModel.state.issues
            .bind(to: issueTableView.rx.items(cellIdentifier: IssueTableViewCell.identifier, cellType: IssueTableViewCell.self)) { _, model, cell in
                cell.viewModel = model
            }
            .disposed(by: disposeBag)
    }
    
    override func attribute() {
        title = "이슈"
        view.backgroundColor = .white
    }
    
    override func layout() {
        view.addSubview(issueTableView)
        
        issueTableView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
