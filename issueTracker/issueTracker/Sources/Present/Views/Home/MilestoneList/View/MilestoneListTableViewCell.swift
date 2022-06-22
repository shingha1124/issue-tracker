//
//  MilestoneListTableViewCell.swift
//  issueTracker
//
//  Created by 이준우 on 2022/06/20.
//

import UIKit

final class MilestoneListTableViewCell: BaseTableViewCell, View {
    
    private let stackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    private let titleView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .black
        return label
    }()
    
    private let progressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = "#34C759".hexToColor()
        label.text = "진행"
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = UIColor.grey1
        label.numberOfLines = 1
        return label
    }()

    private let deadlineView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let deadlineIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ic_calendar")?.withTintColor(.grey1)
        return imageView
    }()
    
    private let deadlineLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.grey1
        label.font = UIFont.systemFont(ofSize: 18)
        label.numberOfLines = 1
        return label
    }()
    
    private let labelView: UIView = {
        let view = UIView()
        return view
    }()

    private let openedIssueCountLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.padding = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = "#007AFF".hexToColor()
        label.backgroundColor = "#C7EBFF".hexToColor()
        label.clipsToBounds = true
        label.layer.cornerRadius = label.intrinsicContentSize.height * 1.5
        return label
    }()

    private let closedIssueCountLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.padding = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = "#0025E7".hexToColor()
        label.backgroundColor = "#CCD4FF".hexToColor()
        label.clipsToBounds = true
        label.layer.cornerRadius = label.intrinsicContentSize.height * 1.5
        return label
    }()
    
    func bind(to viewModel: MilestoneTableViewCellModel) {
        
        viewModel.state.title
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.state.description
            .map { $0.isEmpty }
            .bind(to: descriptionLabel.rx.isHidden)
            .disposed(by: disposeBag)

        viewModel.state.description
            .bind(to: descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.state.deadline
            .map { $0 == nil }
            .bind(to: deadlineView.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.state.deadline
            .map { $0?.string("yyyy-MM-dd") ?? "" }
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
        
        viewModel.state.progress
            .map { "\(String(format: "%.1f", $0))%" }
            .bind(to: progressLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.action.loadData.accept(())
    }
    
    override func layout() {
        super.layout()
        
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(titleView)
        stackView.addArrangedSubview(descriptionLabel)
        stackView.addArrangedSubview(deadlineView)
        stackView.addArrangedSubview(labelView)
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.bottom.equalToSuperview().offset(-22)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        titleView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        titleView.addSubview(progressLabel)
        progressLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        titleView.snp.makeConstraints {
            $0.height.equalTo(titleLabel)
        }
        
        deadlineView.addSubview(deadlineIcon)
        deadlineIcon.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(18)
        }
        
        deadlineView.addSubview(deadlineLabel)
        deadlineLabel.snp.makeConstraints {
            $0.leading.equalTo(deadlineIcon.snp.trailing).offset(5)
            $0.centerY.equalToSuperview()
        }
        
        deadlineView.snp.makeConstraints {
            $0.height.equalTo(deadlineLabel)
        }
        
        labelView.addSubview(openedIssueCountLabel)
        openedIssueCountLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        labelView.addSubview(closedIssueCountLabel)
        closedIssueCountLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalTo(openedIssueCountLabel.snp.trailing).offset(5)
        }
    }
}
