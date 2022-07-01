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
    
    private var commentInsertViewYValue: CGFloat = 0
    private let commentInsertView: CommentInsertView = {
        let view = CommentInsertView()
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.systemGray5.cgColor
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
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
    }
    
    override func attribute() {
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = moreButton
        navigationItem.enableMutiLinedTitle()
        setKeyboardObserver()
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
            $0.top.equalTo(headerView.snp.bottom).offset(15)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(view.safeAreaLayoutGuide.snp.height).multipliedBy(0.8)
        }
        
        view.addSubview(commentInsertView)
        commentInsertView.snp.makeConstraints {
            $0.height.equalToSuperview().multipliedBy(0.05)
            $0.width.equalToSuperview().multipliedBy(0.9)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

extension IssueDetailViewController {
    
    func setKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeShown), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc
    func keyboardWillBeShown(_ notification: NSNotification) {
        guard let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        if commentInsertViewYValue == 0 {
            commentInsertViewYValue = commentInsertView.frame.origin.y
        }
        
        if commentInsertView.frame.origin.y == commentInsertViewYValue {
            let keyboardMinY = keyboardFrame.cgRectValue.minY
            commentInsertViewYValue = commentInsertView.frame.origin.y
            commentInsertView.frame.origin.y = keyboardMinY - commentInsertView.frame.height
        }
    }
    
    @objc
    func keyboardWillBeHidden(_ notification: NSNotification) {
        if commentInsertView.frame.origin.y != commentInsertViewYValue {
            commentInsertView.frame.origin.y = commentInsertViewYValue
        }
    }
}
