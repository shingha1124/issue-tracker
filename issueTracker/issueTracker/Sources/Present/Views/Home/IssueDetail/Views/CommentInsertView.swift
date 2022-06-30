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
            $0.width.height.equalTo(self.snp.height).inset(10)
        }

        addSubview(textField)
        textField.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview().inset(15)
            $0.trailing.equalTo(addButton.snp.leading)
        }
    }
}
