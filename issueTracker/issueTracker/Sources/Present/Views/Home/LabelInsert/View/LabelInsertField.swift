//
//  LabelInsertFormView.swift
//  issueTracker
//
//  Created by 이준우 on 2022/06/15.
//
import UIKit
import SnapKit

final class LabelInsertField: BaseView {
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        return label
    }()
    
    private (set)var textField: UITextField
    
    init(title: String, textField: UITextField) {
        self.titleLabel.text = title
        self.textField = textField
        super.init(frame: .zero)
    }

    override func layout() {
        super.layout()
        
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.equalToSuperview().offset(15)
            $0.width.equalToSuperview().multipliedBy(0.3)
            $0.bottom.equalToSuperview().offset(-10)
        }
            
        self.addSubview(textField)
        textField.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.equalTo(titleLabel.snp.trailing)
            $0.trailing.equalToSuperview().offset(-15)
            $0.bottom.equalToSuperview().offset(-10)
        }
    }
}
