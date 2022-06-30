//
//  IssueDetailViewController.swift
//  issueTracker
//
//  Created by 이준우 on 2022/06/28.
//

import RxCocoa
import RxSwift
import UIKit

final class IssueDetailViewController: BaseViewController, View {
    
    private let headerView: IssueDetailHeaderView = {
        let view = IssueDetailHeaderView()
        return view
    }()
    
    private let commentTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorColor = .separator1
        return tableView
    }()
    
    var disposeBag = DisposeBag()
    
    func bind(to viewModel: IssueDetailViewModel) {
        
        rx.viewWillAppear
            .withUnretained(self)
            .bind(onNext: { vc, _ in
                let appearance = UINavigationBarAppearance()
                appearance.backgroundColor = .white
                
                vc.navigationController?.navigationBar.standardAppearance = appearance
                vc.navigationController?.navigationBar.scrollEdgeAppearance = appearance
                vc.navigationController?.navigationBar.prefersLargeTitles = true
                
                vc.viewModel?.action.loadData.accept(())
            })
            .disposed(by: disposeBag)
        
        viewModel.state.issueTitle
            .bind(to: rx.title)
            .disposed(by: disposeBag)
        
        viewModel.state.issueNumber
            .withUnretained(self)
            .bind(onNext: { vc, num in
                vc.headerView.issueNumber = num
            })
            .disposed(by: disposeBag)
        
        viewModel.state.issueDate
            .withUnretained(self)
            .bind(onNext: { vc, date in
                vc.headerView.history = date.description
            })
            .disposed(by: disposeBag)
    }
    
    override func attribute() {
        view.backgroundColor = .systemBackground
        navigationItem.enableMutiLinedTitle()
    }
    
    override func layout() {
        super.layout()
        
        view.addSubview(headerView)
        headerView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(15)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }
}
