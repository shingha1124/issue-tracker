//
//  LabelInsertViewController.swift
//  issueTracker
//
//  Created by 이준우 on 2022/06/15.
//
import UIKit
import SnapKit
import RxCocoa
import RxSwift

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
    
    private let previewLabel: UILabel = {
        let label = UILabel()
        label.text = "레이블"
        label.backgroundColor = .blue
        label.textColor = .white
        label.clipsToBounds = true
        label.layer.cornerRadius = 10
        label.textAlignment = .center
        label.sizeToFit()
        return label
    }()
    
    var disposeBag = DisposeBag()
    
    func bind(to viewModel: LabelInsertViewModel) {
        /*
            - 사용자 입력값을 뷰모델의 속성과 바인딩
         */
        self.insertForm.titleForm
            .textField.rx.text.orEmpty
            .bind(to: viewModel.action.enteredTitleValue)
            .disposed(by: disposeBag)
        
        self.insertForm.descriptionForm
            .textField.rx.text.orEmpty
            .bind(to: viewModel.action.enteredDescriptionValue)
            .disposed(by: disposeBag)
        
        self.insertForm.colorForm
            .textField.rx.text.orEmpty
            .bind(to: viewModel.action.enteredRgbValue)
            .disposed(by: disposeBag)
        
        self.insertForm.colorChangeButton.rx.tap
            .bind(onNext: { _ in
                let rgbValue = self.insertForm.colorForm.textField.text ?? ""
                self.viewModel?.action.enteredRgbValue
                    .accept(rgbValue)
            })
            .disposed(by: disposeBag)
        
        /*
            - 뷰모델의 속성변화를 감지
            - 뷰모델의 변화된 속성값을 읽어들여 뷰에 출력
         */
        self.viewModel?.state
            .updatedTitleValue
            .bind(to: previewLabel.rx.text)
            .disposed(by: disposeBag)
        
        self.viewModel?.state
            .updatedRgbValue
            .bind(onNext: { rgbValue in
                //라벨 색상 바꿔줘야 함
                Log.debug("value changed to \(rgbValue)")
            })
            .disposed(by: disposeBag)
        
        rx.viewWillDisappear
            .withUnretained(self)
            .bind(onNext: { _ in
                self.navigationController?.navigationBar.prefersLargeTitles = true
            })
            .disposed(by: disposeBag)
    }
    
    override func attribute() {
        super.attribute()
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.view.backgroundColor = .systemGray6
        self.navigationItem.title = "새로운 레이블"
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
