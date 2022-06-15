//
//  LabelInsertForm.swift
//  issueTracker
//
//  Created by 이준우 on 2022/06/15.
//
import UIKit

final class LabelInsertForm: BaseView {
    
    let titleForm: LabelInsertField = {
        let textField = UITextField()
        textField.placeholder = "필수 입력"
        
        let form = LabelInsertField(title: "제목", textField: textField)
        form.backgroundColor = .white
        return form
    }()
    
    let descriptionForm: LabelInsertField = {
        let textField = UITextField()
        textField.placeholder = "선택 사항"
        
        let form = LabelInsertField(title: "설명", textField: textField)
        form.backgroundColor = .white
        return form
    }()
    
    let colorForm: LabelInsertField = {
        let textField = UITextField()
        textField.text = "#c5def5"
     
        let form = LabelInsertField(title: "배경색", textField: textField)
        form.backgroundColor = .white
        return form
    }()
    
    let colorChangeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
        button.sizeToFit()
        return button
    }()
    
    private let formStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.backgroundColor = .white
        return stackView
    }()
    
    override func attribute() {
        super.attribute()
        self.backgroundColor = .white
        self.colorForm.textField.rightViewMode = .always
        self.colorForm.textField.rightView = self.colorChangeButton
    }
    
    override func layout() {
        super.layout()
        self.addSubview(formStackView)
        formStackView.addArrangedSubview(titleForm)
        formStackView.addArrangedSubview(descriptionForm)
        formStackView.addArrangedSubview(colorForm)
        
        formStackView.snp.makeConstraints {
            $0.top.bottom.width.equalToSuperview()
        }
    }
}
