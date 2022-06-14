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
//        tableView.
        return tableView
    }()
    
    var disposeBag = DisposeBag()
    
    func bind(to viewModel: IssueListViewModel) {
        rx.viewDidLoad
            .bind(to: viewModel.action.requestIssue)
            .disposed(by: disposeBag)
    }
    
    override func attribute() {
        view.backgroundColor = .red
    }
}
