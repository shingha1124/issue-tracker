//
//  LabelInsertFormView.swift
//  issueTracker
//
//  Created by 이준우 on 2022/06/15.
//
import RxCocoa
import RxSwift
import SnapKit
import UIKit

final class LabelInsertField: BaseView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        return label
    }()
    
    private let textField = UITextField()
   
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    var placeHolder: String? {
        didSet {
            textField.placeholder = placeHolder
        }
    }
    
    var rightButton: UIButton? {
        didSet {
            textField.rightViewMode = .always
            textField.rightView = rightButton
        }
    }
    
    var text: String? {
        didSet {
            textField.text = text
        }
    }
    
    var didChange: ControlProperty<String?> {
        textField.rx.text
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
