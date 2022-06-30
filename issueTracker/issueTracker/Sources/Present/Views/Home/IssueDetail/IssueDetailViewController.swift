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
        tableView.register(CommentTableViewCell.self,
                           forCellReuseIdentifier: CommentTableViewCell.identifier)
        return tableView
    }()
    
    private let moreButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.image = UIImage(systemName: "ellipsis")
        return button
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
        
        rx.viewDidLoad
            .bind(to: viewModel.action.requestComments)
            .disposed(by: disposeBag)
        
        viewModel.state.comments
            .bind(to: commentTableView.rx.items(cellIdentifier: CommentTableViewCell.identifier, cellType: CommentTableViewCell.self)) { _, viewModel, cell in
                cell.viewModel = viewModel
            }
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
        
        moreButton.rx.tap
            .bind(to: viewModel.action.tappedMoreButton)
            .disposed(by: disposeBag)
    }
    
    override func attribute() {
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = moreButton
        navigationItem.enableMutiLinedTitle()
    }
    
    override func layout() {
        super.layout()
        
        view.addSubview(headerView)
        headerView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(15)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        view.addSubview(commentTableView)
        commentTableView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
