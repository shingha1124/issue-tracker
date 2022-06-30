//
//  IssueDetailTableViewCell.swift
//  issueTracker
//
//  Created by 이준우 on 2022/06/30.
//

import SwiftyMarkdown
import UIKit

final class CommentTableViewCell: BaseTableViewCell, View {
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.distribution = .fill
        return stackView
    }()
    
    private let writerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.sizeToFit()
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .gray
        label.numberOfLines = 5
        label.sizeToFit()
        return label
    }()
    
    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 0
        label.sizeToFit()
        return label
    }()
    
    private let avatarImage: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    func bind(to viewModel: CommentTableViewCellModel) {
        
        viewModel.state.body
            .map { SwiftyMarkdown(string: $0).attributedString() }
            .bind(to: bodyLabel.rx.attributedText)
            .disposed(by: disposeBag)
        
        viewModel.state.createdAt
            .map { $0.string("yyyy-MM-dd HH:mm") }
            .bind(to: timeLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.state.user
            .map { $0.login }
            .bind(to: writerLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.state.avatarImage
            .map { UIImage(data: $0) }
            .bind(to: avatarImage.rx.image)
            .disposed(by: disposeBag)
        
        viewModel.action.loadData.accept(())
    }
    
    override func layout() {
        super.layout()
        
        contentView.addSubview(avatarImage)
        avatarImage.snp.makeConstraints {
            $0.top.equalToSuperview().inset(15)
            $0.leading.equalToSuperview().offset(20)
            $0.width.height.equalTo(40)
        }
        
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(writerLabel)
        stackView.addArrangedSubview(timeLabel)
        stackView.addArrangedSubview(bodyLabel)
        stackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(15)
            $0.trailing.equalToSuperview().inset(15)
            $0.leading.equalTo(avatarImage.snp.trailing).offset(20)
        }
    }
}
