//
//  MilestoneListTableViewCell.swift
//  issueTracker
//
//  Created by 이준우 on 2022/06/20.
//

import UIKit

final class MilestoneListTableViewCell: BaseTableViewCell, View {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .black
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.numberOfLines = 1
        return label
    }()

    private let deadlineLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.numberOfLines = 1
        return label
    }()

    private let openedIssueCountLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.padding = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = .black
        label.backgroundColor = .systemBlue
        label.clipsToBounds = true
        label.layer.cornerRadius = label.intrinsicContentSize.height * 1.5
        return label
    }()

    private let closedIssueCountLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.padding = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = .black
        label.backgroundColor = .systemPurple
        label.clipsToBounds = true
        label.layer.cornerRadius = label.intrinsicContentSize.height * 1.5
        return label
    }()
    
    func bind(to viewModel: MilestoneTableViewCellModel) {
        
        viewModel.state.title
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.state.description
            .bind(to: descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.state.deadline
            .map { deadline in
                guard let deadline = deadline else { return "" }
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                return dateFormatter.string(from: deadline)
            }
            .bind(to: deadlineLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.state.openedIssueCount
            .map { "열린 이슈 \($0)개" }
            .bind(to: openedIssueCountLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.state.closedIssueCount
            .map { "닫힌 이슈 \($0)개" }
            .bind(to: closedIssueCountLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.action.loadData.accept(())
    }
    
    override func layout() {
        super.layout()
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(20)
        }
        
        contentView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(20)
        }
        
        contentView.addSubview(deadlineLabel)
        deadlineLabel.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(20)
        }
        
        contentView.addSubview(openedIssueCountLabel)
        openedIssueCountLabel.snp.makeConstraints {
            $0.top.equalTo(deadlineLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(20)
        }
        
        contentView.addSubview(closedIssueCountLabel)
        closedIssueCountLabel.snp.makeConstraints {
            $0.top.equalTo(deadlineLabel.snp.bottom).offset(10)
            $0.leading.equalTo(openedIssueCountLabel.snp.trailing).offset(10)
            $0.bottom.equalToSuperview().offset(-20)
        }
    }
}
