//
//  LabelInsertViewController.swift
//  issueTracker
//
//  Created by 이준우 on 2022/06/15.
//
import RxCocoa
import RxSwift
import SnapKit
import UIKit

final class LabelInsertViewController: BaseViewController, View {
    
    private let insertForm: LabelInsertForm = {
        let insertForm = LabelInsertForm()
        return insertForm
    }()
    
    private let labelBox: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        return view
    }()
    
    private let previewLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.text = "Labels".localized()
        label.padding = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        label.backgroundColor = .systemCyan
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = .black
        label.clipsToBounds = true
        label.layer.cornerRadius = 15
        label.sizeToFit()
        return label
    }()
    
    private let addButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.title = "Save".localized()
        button.style = .plain
        return button
    }()
    
    private let cancelButton: UIBarButtonItem = {
       let button = UIBarButtonItem()
        button.title = "Cancel".localized()
        button.style = .done
        return button
    }()

    var disposeBag = DisposeBag()
    
    func bind(to viewModel: LabelInsertViewModel) {
     
        rx.viewDidLoad
            .bind(to: viewModel.action.viewDidLoad)
            .disposed(by: disposeBag)
        
        insertForm.titleField.didChange
            .compactMap { $0 }
            .bind(to: viewModel.action.enteredTitleValue)
            .disposed(by: disposeBag)
        
        insertForm.descriptionField.didChange
            .compactMap { $0 }
            .bind(to: viewModel.action.enteredDescriptionValue)
            .disposed(by: disposeBag)
        
        insertForm.colorChangeButton.rx.tap
            .bind(to: viewModel.action.tappedColorChangeButton)
            .disposed(by: disposeBag)
        
        addButton.rx.tap
            .bind(to: viewModel.action.tappedAddingLabelButton)
            .disposed(by: disposeBag)
        
        cancelButton.rx.tap
            .bind(to: viewModel.action.tappedCancelButton)
            .disposed(by: disposeBag)
        
        viewModel.state.updatedTitleValue
            .bind(to: previewLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.state.updatedRgbValue
            .bind(to: insertForm.colorField.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.state.updatedRgbValue
            .map { try HexToColor.transform(form: String($0.dropFirst())) }
            .withUnretained(self)
            .do { vc, color in
                vc.previewLabel.textColor = color.contrast
            }
            .map { _, color in color }
            .bind(to: previewLabel.rx.backgroundColor )
            .disposed(by: disposeBag)
    }
    
    override func attribute() {
        super.attribute()
        view.backgroundColor = .systemGray6
        navigationItem.title = "New Labels".localized()
        navigationItem.rightBarButtonItem = addButton
        navigationItem.leftBarButtonItem = cancelButton
    }
    
    override func layout() {
        super.layout()

        view.addSubview(insertForm)
        insertForm.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(20)
            $0.width.equalToSuperview()
        }

        view.addSubview(labelBox)
        labelBox.snp.makeConstraints {
            $0.top.equalTo(insertForm.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalToSuperview().multipliedBy(0.3)
        }

        labelBox.addSubview(previewLabel)
        previewLabel.snp.makeConstraints {
            $0.centerX.centerY.equalTo(labelBox)
            $0.height.equalTo(labelBox).multipliedBy(0.13)
        }
    }
}
