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
        titleLabel.snp.makeConstraints { titleLabel in
            titleLabel.top.equalTo(self).offset(10)
            titleLabel.leading.equalTo(self).offset(15)
            titleLabel.width.equalTo(self).multipliedBy(0.3)
            titleLabel.bottom.equalTo(self).offset(-10)
        }
            
        self.addSubview(textField)
        textField.snp.makeConstraints { textField in
            textField.top.equalTo(self).offset(10)
            textField.leading.equalTo(titleLabel.snp.trailing)
            textField.trailing.equalTo(self).offset(-15)
            textField.bottom.equalTo(self).offset(-10)
        }
    }
}
