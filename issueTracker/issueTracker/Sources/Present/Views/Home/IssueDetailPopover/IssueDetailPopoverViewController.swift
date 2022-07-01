//
//  SheetViewController.swift
//  issueTracker
//
//  Created by seongha shin on 2022/06/30.
//

import RxSwift
import UIKit

final class IssueDetailPopoverViewController: BaseViewController, View {
    
    let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .backGround2
        return view
    }()
    
    let titleView: UIView = {
        let view = UIView()
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "이슈 상세 정보"
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        return label
    }()
    
    let itemStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.backgroundColor = .grey5
        stackView.spacing = 1
        stackView.clipsToBounds = true
        stackView.layer.cornerRadius = 10
        return stackView
    }()
    
    var disposeBag = DisposeBag()
    
    func bind(to viewModel: IssueDetailPopoverViewModel) {
        rx.viewDidLoad
            .bind(to: viewModel.action.viewDidLoad)
            .disposed(by: disposeBag)
        
        viewModel.state.models
            .withUnretained(self)
            .do { vc, models in
                models.forEach { model in
                    let view = IssueDetailPopoverItemView()
                    view.viewModel = model
                    vc.itemStackView.addArrangedSubview(view)
                }
            }
            .bind(onNext: { vc, _ in
                vc.view.layoutIfNeeded()
                let dentent: UISheetPresentationController.Detent = ._detent(withIdentifier: "dentent", constant: vc.contentView.frame.height)
                vc.sheetPresentationController?.detents = [dentent, .medium(), .large()]
            })
            .disposed(by: disposeBag)
    }
    
    override func attribute() {
        view.backgroundColor = .backGround2
    }
    
    override func layout() {
        view.addSubview(contentView)
        contentView.addSubview(titleView)
        contentView.addSubview(itemStackView)
        titleView.addSubview(titleLabel)
        
        contentView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(itemStackView).offset(30)
        }
        
        titleView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalToSuperview().offset(21)
            $0.bottom.equalTo(titleLabel)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.top.equalToSuperview()
        }
        
        itemStackView.snp.makeConstraints {
            $0.top.equalTo(titleView.snp.bottom).offset(25)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
    }
}
