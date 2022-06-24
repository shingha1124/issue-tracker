//
//  MilestoneInsertForm.swift
//  issueTracker
//
//  Created by 이준우 on 2022/06/21.
//

import Foundation
import UIKit

final class MilestoneInsertForm: BaseView {
    
    let titleField: InsertField = {
        let form = InsertField()
        form.title = "Title".localized()
        form.placeHolder = "Require".localized()
        form.backgroundColor = .white
        return form
    }()
    
    let descriptionField: InsertField = {
        let form = InsertField()
        form.title = "Description".localized()
        form.placeHolder = "Option".localized()
        form.backgroundColor = .white
        return form
    }()
    
    let deadlineField: InsertField = {
        let form = InsertField()
        form.title = "DueDate".localized()
        form.placeHolder = "Option".localized() + "(YYYY-MM-DD)"
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
        formStackView.addArrangedSubview(titleField)
        formStackView.addArrangedSubview(descriptionField)
        formStackView.addArrangedSubview(deadlineField)
        
        formStackView.snp.makeConstraints {
            $0.top.bottom.width.equalToSuperview()
        }
    }
}
