//
//  LabelListTableViewCell.swift
//  issueTracker
//
//  Created by 이준우 on 2022/06/15.
//

import UIKit

final class LabelListTableViewCell: BaseTableViewCell, View {
    
    private let paddingLabel: PaddingLabel = {
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
    
    var paddingLabelColor: UIColor? {
        didSet {
            paddingLabel.backgroundColor = paddingLabelColor
            paddingLabel.textColor = paddingLabelColor?.contrast ?? .black
        }
    }
    
    func bind(to viewModel: LabelListTableViewCellModel) {
        
        viewModel.state.name
            .bind(to: paddingLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.state.description
            .bind(to: descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.state.color
            .map { $0.hexToColor() }
            .withUnretained(self)
            .bind(onNext: { cell, color in
                cell.paddingLabelColor = color
            })
            .disposed(by: disposeBag)
        
        viewModel.action.loadData.accept(())
    }
    
    override func layout() {
        super.layout()
        
        contentView.addSubview(paddingLabel)
        paddingLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(20)
        }
        
        contentView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(paddingLabel.snp.bottom).offset(20)
            $0.bottom.equalToSuperview().offset(-20)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-10)
        }
    }
}
