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
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorColor = .separator1
        tableView.backgroundColor = .backGround2
        tableView.register(IssueTableViewCell.self, forCellReuseIdentifier: IssueTableViewCell.identifier)
        return tableView
    }()
    
    private let filterButton: UIButton = {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .light, scale: .small)
        let image = UIImage(systemName: "line.3.horizontal.decrease", withConfiguration: imageConfig)
        
        var config = UIButton.Configuration.plain()
        config.image = image
        config.imagePlacement = .leading
        config.imagePadding = 4
        config.title = "필터"
        config.contentInsets = .zero
        
        let button = UIButton(configuration: config)
        return button
    }()
    
    private let selectButton: UIButton = {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .light, scale: .small)
        let image = UIImage(systemName: "checkmark.circle", withConfiguration: imageConfig)
        
        var config = UIButton.Configuration.plain()
        config.image = image
        config.imagePlacement = .trailing
        config.imagePadding = 4
        config.title = "선택"
        config.contentInsets = .zero
        
        let button = UIButton(configuration: config)
        return button
    }()
    
    private let loadingIndicatorView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView(style: .large)
        return indicatorView
    }()
    
    private let searchController: UISearchController = {
        let searchController = UISearchController()
        return searchController
    }()
    
    var disposeBag = DisposeBag()
    
    func bind(to viewModel: IssueListViewModel) {
        rx.viewDidLoad
            .bind(to: viewModel.action.requestIssue)
            .disposed(by: disposeBag)
        
        rx.viewDidAppear
            .withUnretained(self)
            .bind(onNext: { vc, _ in
                let appearance = UINavigationBarAppearance()
                appearance.backgroundColor = .white
                appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
                appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
                vc.navigationController?.navigationBar.standardAppearance = appearance
                vc.navigationController?.navigationBar.scrollEdgeAppearance = appearance
                vc.navigationController?.navigationBar.prefersLargeTitles = true
                
                vc.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: vc.filterButton)
                vc.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: vc.selectButton)
            })
            .disposed(by: disposeBag)
        
        viewModel.state.issues
            .bind(to: issueTableView.rx.items(cellIdentifier: IssueTableViewCell.identifier, cellType: IssueTableViewCell.self)) { _, model, cell in
                cell.viewModel = model
            }
            .disposed(by: disposeBag)
        
        viewModel.state.issues
            .withUnretained(self)
            .map { vc, issues -> [IndexPath: UISwipeActionsConfiguration] in
                let keyValue = issues.enumerated().map { index, _ in
                    (IndexPath(row: index, section: 0), vc.maketrailingSwipeActions(index))
                }
                return Dictionary(uniqueKeysWithValues: keyValue)
            }
            .bind(to: issueTableView.rx.trailingSwipeActionsConfigurationForRowAt)
            .disposed(by: disposeBag)
        
        viewModel.state.issues
            .filter { $0.count > 4 }
            .withUnretained(self)
            .bind(onNext: { vc, _ in
                vc.navigationItem.searchController = vc.searchController
            })
            .disposed(by: disposeBag)

        viewModel.state.enableLoadingIndactorView
            .withUnretained(self)
            .bind(onNext: { vc, enable in
                enable ? vc.loadingIndicatorView.startAnimating() : vc.loadingIndicatorView.stopAnimating()
            })
            .disposed(by: disposeBag)
        
        filterButton.rx.tap
            .bind(onNext: {
                print("zxcvzxvxcvv")
            })
            .disposed(by: disposeBag)
    }
    
    override func attribute() {
        title = "이슈"
        view.backgroundColor = .white
    }
    
    override func layout() {
        view.addSubview(issueTableView)
        view.addSubview(loadingIndicatorView)
        
        issueTableView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        loadingIndicatorView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension IssueListViewController {
    func maketrailingSwipeActions(_ index: Int) -> UISwipeActionsConfiguration {
        let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { [weak self] _, _, completionHandler in
            self?.viewModel?.action.deleteIssue.accept(index)
            completionHandler(true)
        }
        deleteAction.image = UIImage(named: "ic_trash")?.withTintColor(.white)
        deleteAction.backgroundColor = .error
        
        let closeAction = UIContextualAction(style: .normal, title: "닫기") { _, _, completionHandler in
            completionHandler(true)
        }
        closeAction.image = UIImage(named: "ic_archive")?.withTintColor(.white)
        closeAction.backgroundColor = .grey1
        
        let config = UISwipeActionsConfiguration(actions: [closeAction, deleteAction])
        config.performsFirstActionWithFullSwipe = false

        return config
    }
}
