//
//  MilestoneInsertForm.swift
//  issueTracker
//
//  Created by 이준우 on 2022/06/21.
//

import Foundation

import UIKit

final class MilestoneInsertForm: BaseView {
    
    let titleForm: LabelInsertField = {
        let form = LabelInsertField()
        form.title = "제목"
        form.placeHolder = "필수 입력"
        form.backgroundColor = .white
        return form
    }()
    
    let descriptionForm: LabelInsertField = {
        let form = LabelInsertField()
        form.title = "설명"
        form.placeHolder = "선택사항"
        form.backgroundColor = .white
        return form
    }()
    
    let deadlineForm: LabelInsertField = {
        let form = LabelInsertField()
        form.title = "완료일"
        form.placeHolder = "선택사항(YYYY-MM-DD)"
        form.backgroundColor = .white
        return form
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
    }
    
    override func layout() {
        super.layout()
        self.addSubview(formStackView)
        formStackView.addArrangedSubview(titleForm)
        formStackView.addArrangedSubview(descriptionForm)
        formStackView.addArrangedSubview(deadlineForm)
        
        formStackView.snp.makeConstraints {
            $0.top.bottom.width.equalToSuperview()
        }
    }
}
