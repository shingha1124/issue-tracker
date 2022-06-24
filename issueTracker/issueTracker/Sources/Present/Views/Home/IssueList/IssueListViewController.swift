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
        config.title = "Filter".localized()
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
        config.title = "Select".localized()
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
    
    private let addIssueButton: UIButton = {
        let button = UIButton()
        button.clipsToBounds = true
        button.backgroundColor = .primary1
        button.layer.cornerRadius = 32
        return button
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
                    (IndexPath(row: index, section: 0), vc.makeTrailingSwipeActions(index))
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
    }
    
    override func attribute() {
        title = "Issue".localized()
        view.backgroundColor = .white
    }
    
    override func layout() {
        view.addSubview(issueTableView)
        view.addSubview(loadingIndicatorView)
        view.addSubview(addIssueButton)
        
        issueTableView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        loadingIndicatorView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        addIssueButton.snp.makeConstraints {
            $0.bottom.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.width.height.equalTo(64)
        }
    }
}

extension IssueListViewController {
    func makeTrailingSwipeActions(_ index: Int) -> UISwipeActionsConfiguration {
        let closeAction = UIContextualAction(style: .normal, title: "Close".localized()) { [weak self] _, _, completionHandler in
            self?.viewModel?.action.closeIssue.accept(index)
            completionHandler(true)
        }
        
        closeAction.image = UIImage(named: "ic_archive")?.withTintColor(.white)
        closeAction.backgroundColor = .grey1
        
        let config = UISwipeActionsConfiguration(actions: [closeAction])
        config.performsFirstActionWithFullSwipe = false

        return config
    }
}
