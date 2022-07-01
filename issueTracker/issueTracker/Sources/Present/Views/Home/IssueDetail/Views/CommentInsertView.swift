//
//  CommentInsertView.swift
//  issueTracker
//
//  Created by 이준우 on 2022/07/01.
//

import SnapKit
import UIKit

final class CommentInsertView: BaseView {
    
    let textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "코멘트를 입력하세요"
        textField.clipsToBounds = true
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 5
        return textField
    }()
    
    let addButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.up"), for: .normal)
        return button
    }()

    override func layout() {
        super.layout()

        addSubview(addButton)
        addButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(15)
            $0.width.height.equalTo(snp.height).inset(10)
        }

        addSubview(textField)
        textField.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-5)
            $0.leading.equalToSuperview().inset(15)
            $0.trailing.equalTo(addButton.snp.leading).offset(-10)
        }
        
        snp.makeConstraints {
            $0.top.equalTo(textField).offset(-5)
        }
    }
}
