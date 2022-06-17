//
//  LabelListTableViewCell.swift
//  issueTracker
//
//  Created by 이준우 on 2022/06/15.
//

import UIKit

final class LabelListTableViewCell: BaseTableViewCell {
    
    private lazy var paddingLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.padding = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = .black
        label.clipsToBounds = true
        label.layer.cornerRadius = label.intrinsicContentSize.height * 1.5
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.numberOfLines = 1
        return label
    }()
    
    override func layout() {

        contentView.addSubview(paddingLabel)
        paddingLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(10)
        }
        
        contentView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(paddingLabel.snp.bottom).offset(20)
            $0.bottom.equalToSuperview().offset(-20)
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().offset(-10)
        }
    }
    
    func updateValues(labelName: String, description: String, color: UIColor) {
        self.paddingLabel.text = labelName
        self.descriptionLabel.text = description
        self.paddingLabel.backgroundColor = color
    }
}
