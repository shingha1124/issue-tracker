//
//  LabelListTableViewCell.swift
//  issueTracker
//
//  Created by 이준우 on 2022/06/15.
//

import UIKit

final class LabelListTableViewCell: BaseTableViewCell {
    
    private let paddingLabel: PaddingLabel = {
        let paddingLabel = PaddingLabel()
        paddingLabel.backgroundColor = .systemCyan
        return paddingLabel
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
            $0.top.equalToSuperview().offset(10)
            $0.leading.equalToSuperview().offset(10)
        }
        
        contentView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(paddingLabel.snp.bottom).offset(10)
            $0.bottom.equalToSuperview().offset(-10)
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().offset(-10)
        }
    }
    
    func updateValues(labelName: String, description: String) {
        self.paddingLabel.text = labelName
        self.descriptionLabel.text = description
    }
}
