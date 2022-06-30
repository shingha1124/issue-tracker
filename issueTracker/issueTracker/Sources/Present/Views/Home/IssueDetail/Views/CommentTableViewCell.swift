//
//  IssueDetailTableViewCell.swift
//  issueTracker
//
//  Created by 이준우 on 2022/06/30.
//

import UIKit

final class CommentTableViewCell: BaseTableViewCell, View {
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fill
        return stackView
    }()
    
    private let writerLabel: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 5
        label.sizeToFit()
        return label
    }()
    
    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .black
        label.numberOfLines = 0
        label.sizeToFit()
        return label
    }()
    
    func bind(to viewModel: CommentTableViewCellModel) {
        
        viewModel.state.body
            .bind(to: bodyLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.state.createdAt
            .map { $0.string("yyyy-MM-dd") }
            .bind(to: timeLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.action.loadData.accept(())
    }
    
    override func layout() {
        super.layout()
        
        contentView.addSubview(stackView)
        
        stackView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview().inset(15)
        }
        
        stackView.addArrangedSubview(writerLabel)
        stackView.addArrangedSubview(timeLabel)
        stackView.addArrangedSubview(bodyLabel)
    }
}
