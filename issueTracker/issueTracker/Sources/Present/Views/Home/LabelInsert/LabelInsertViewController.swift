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
        label.text = "레이블"
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
        button.title = "저장"
        button.style = .plain
        return button
    }()

    var disposeBag = DisposeBag()
    
    func bind(to viewModel: LabelInsertViewModel) {
        /*
            - 사용자 입력값을 뷰모델의 속성과 바인딩
         */
        rx.viewDidLoad
            .bind(to: viewModel.action.viewDidLoad)
            .disposed(by: disposeBag)
        
        insertForm.titleForm.didChange
            .compactMap { $0 }
            .bind(to: viewModel.action.enteredTitleValue)
            .disposed(by: disposeBag)
        
        insertForm.descriptionForm.didChange
            .compactMap { $0 }
            .bind(to: viewModel.action.enteredDescriptionValue)
            .disposed(by: disposeBag)
        
        insertForm.colorChangeButton.rx.tap
            .bind(to: viewModel.action.tappedColorChangeButton)
            .disposed(by: disposeBag)
        
        addButton.rx.tap
            .bind(to: viewModel.action.tappedAddingLabelButton)
            .disposed(by: disposeBag)
        
        /*
            - 뷰모델의 속성변화를 감지
            - 뷰모델의 변화된 속성값을 읽어들여 뷰에 출력
         */
        viewModel.state.updatedTitleValue
            .bind(to: previewLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.state.updatedRgbValue
            .bind(to: insertForm.colorForm.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.state.updatedRgbValue
            .map { try HexToColor.transform(form: $0) }
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
        self.view.backgroundColor = .systemGray6
        self.navigationItem.title = "새로운 레이블"
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    override func layout() {
        super.layout()

        self.view.addSubview(insertForm)
        insertForm.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(20)
            $0.width.equalToSuperview()
        }

        self.view.addSubview(labelBox)
        labelBox.snp.makeConstraints {
            $0.top.equalTo(insertForm.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalToSuperview().multipliedBy(0.3)
        }

        self.labelBox.addSubview(previewLabel)
        previewLabel.snp.makeConstraints {
            $0.centerX.centerY.equalTo(labelBox)
            $0.height.equalTo(labelBox).multipliedBy(0.13)
        }
    }
}
