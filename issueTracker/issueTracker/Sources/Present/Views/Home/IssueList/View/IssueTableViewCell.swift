//
//  IssueTableViewCell.swift
//  issueTracker
//
//  Created by seongha shin on 2022/06/14.
//

import UIKit

final class IssueTableViewCell: BaseTableViewCell, View {
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.textColor = .black
        return label
    }()
    
    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        label.textColor = .grey1
        return label
    }()
    
    private let milestoneView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let milestoneIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ic_milestone")?.withTintColor(.grey1)
        imageView.tintColor = .grey1
        return imageView
    }()
    
    private let milestoneLabel: UILabel = {
        let label = UILabel()
        label.textColor = .grey1
        label.font = .systemFont(ofSize: 17, weight: .regular)
        return label
    }()
    
    private let labels: TagListView = {
        let config = TagListView.Config()
        config.font = .systemFont(ofSize: 17, weight: .regular)
        config.isCapsule = true
        let tagListView = TagListView(config: config)
        
        return tagListView
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        labels.clear()
    }
    
    func bind(to viewModel: IssueTableViewCellModel) {
        
        viewModel.state.title
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.state.body
            .bind(to: bodyLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.state.body
            .map { $0 == nil }
            .bind(to: bodyLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.state.milestone
            .bind(to: milestoneLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.state.milestone
            .map { $0 == nil }
            .bind(to: milestoneView.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.state.labels
            .map {
                $0.map { label -> TagListView.Tag in
                    let config = TagListView.TagConfig()
                    config.textColor = label.color.hexToColor().contrast
                    config.backgroundColor = label.color.hexToColor()
                    return TagListView.Tag(text: label.name, config: config)
                }
            }
            .withUnretained(self)
            .do { vc, labels in
                vc.labels.addTags(labels)
            }
            .map { _ in }
            .bind(onNext: labels.updateTag)
            .disposed(by: disposeBag)
        
        viewModel.state.labels
            .map { $0.isEmpty }
            .bind(to: labels.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.action.loadData.accept(())
    }
    
    override func attribute() {
        
    }
    
    override func layout() {
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(bodyLabel)
        stackView.addArrangedSubview(milestoneView)
        stackView.addArrangedSubview(labels)
        
        milestoneView.addSubview(milestoneIcon)
        milestoneView.addSubview(milestoneLabel)
        
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        milestoneIcon.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(18)
        }
        
        milestoneLabel.snp.makeConstraints {
            $0.leading.equalTo(milestoneIcon.snp.trailing).offset(4)
            $0.top.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
        
        milestoneView.snp.makeConstraints {
            $0.height.equalTo(milestoneLabel)
        }
        
        contentView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(stackView).offset(24)
        }
    }
}
