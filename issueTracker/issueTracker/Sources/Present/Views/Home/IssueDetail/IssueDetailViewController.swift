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
        tableView.backgroundColor = .systemGray6
        tableView.separatorColor = .separator1
        tableView.register(CommentTableViewCell.self,
                           forCellReuseIdentifier: CommentTableViewCell.identifier)
        tableView.keyboardDismissMode = .onDrag
        return tableView
    }()
    
    private let moreButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.image = UIImage(systemName: "ellipsis")
        return button
    }()
    
    private let commentInsertView: CommentInsertView = {
        let view = CommentInsertView()
        view.backgroundColor = .systemBackground
        return view
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
            .map { "\($0.string("yyyy-MM-dd HH:mm")) 작성" }
            .withUnretained(self)
            .bind(onNext: { vc, date in
                vc.headerView.history = date
            })
            .disposed(by: disposeBag)
        
        moreButton.rx.tap
            .bind(to: viewModel.action.tappedMoreButton)
            .disposed(by: disposeBag)
        
        commentInsertView.textField.rx.text
            .compactMap { $0 }
            .bind(to: viewModel.action.inputComment)
            .disposed(by: disposeBag)
        
        commentInsertView.addButton.rx.tap
            .bind(to: viewModel.action.requestCreatingComment)
            .disposed(by: disposeBag)
        
        Observable
            .merge(
                NotificationCenter.keyboardWillHideHeight.map { (true, $0) },
                NotificationCenter.keyboardWillShowHeight.map { (false, $0) }
            )
            .withUnretained(self)
            .bind(onNext: { vc, keyboardValue in
                let (isHidden, value) = keyboardValue
                let offsetHeight = isHidden ? 0 : vc.view.safeAreaInsets.bottom
                UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseOut, animations: {
                    vc.commentInsertView.snp.updateConstraints {
                        $0.bottom.equalTo(vc.view.safeAreaLayoutGuide.snp.bottom).inset(value - offsetHeight)
                    }
                    vc.commentInsertView.superview?.layoutIfNeeded()
                })
            })
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
        view.addSubview(commentInsertView)
        view.addSubview(commentTableView)
        
        headerView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(15)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        commentTableView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(15)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(commentInsertView.snp.top)
        }
        
        commentInsertView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
