//
//  AddIssueViewController.swift
//  issueTracker
//
//  Created by seongha shin on 2022/06/24.
//

import RxSwift
import UIKit

final class AddIssueViewController: BaseViewController, View {

    private let saveButton: UIButton = {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .light, scale: .small)
        let image = UIImage(systemName: "plus", withConfiguration: imageConfig)

        var config = UIButton.Configuration.plain()
        config.image = image
        config.imagePlacement = .trailing
        config.imagePadding = 4
        config.title = "Save".localized()
        config.contentInsets = .zero

        let button = UIButton(configuration: config)
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.text = "Title".localized()
        label.textColor = .black
        return label
    }()
    
    private let titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Title".localized()
        textField.font = .systemFont(ofSize: 17, weight: .regular)
        textField.textColor = .black
        textField.textAlignment = .left
        return textField
    }()
    
    private let separator: UIView = {
        let view = UIView()
        view.backgroundColor = .separator1
        return view
    }()
    
    private let bodyTextView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 17, weight: .regular)
        textView.textColor = .black
        return textView
    }()
    
    private let bodySegment: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["마크다운", "미리보기"])
        segment.selectedSegmentIndex = 0
        return segment
    }()
    
    private let additionalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    
    var disposeBag = DisposeBag()
    
    func bind(to viewModel: AddIssueViewModel) {
        rx.viewDidLoad
            .bind(to: viewModel.action.viewDidLoad)
            .disposed(by: disposeBag)
        
        rx.viewDidAppear
            .withUnretained(self)
            .bind(onNext: { vc, _ in
                vc.navigationController?.navigationBar.prefersLargeTitles = false
                vc.navigationItem.titleView = vc.bodySegment
            })
            .disposed(by: disposeBag)
        
        viewModel.state.additionalInfoViewModels
            .withUnretained(self)
            .bind(onNext: { vc, models in
                models.forEach {
                    let itemView = AdditionalInfoItemView()
                    itemView.viewModel = $0
                    vc.additionalStackView.addArrangedSubview(itemView)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.state.presentAlert
            .map { type, titles -> (type: AdditionalType, actions: [UIAlertAction]) in
                let actions = titles.enumerated().map { index, title in
                    UIAlertAction(title: title, style: .default) { _ in
                        viewModel.action.selectAlertItem.accept((type, index))
                    }
                }
                
                return (type, actions)
            }
            .withUnretained(self)
            .bind(onNext: { vc, alertData in
                let alert = UIAlertController(title: alertData.type.title, message: nil, preferredStyle: .actionSheet)
                alertData.actions.forEach {
                    alert.addAction($0)
                }
                alert.addAction(UIAlertAction(title: "Cancel".localized(), style: .cancel))
                vc.present(alert, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    override func attribute() {
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: saveButton)
    }
    
    override func layout() {
        view.addSubview(titleLabel)
        view.addSubview(titleTextField)
        view.addSubview(separator)
        view.addSubview(bodyTextView)
        view.addSubview(additionalStackView)
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(11)
            $0.width.equalTo(66)
        }
        
        titleTextField.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.trailing)
            $0.trailing.equalToSuperview().offset(-16)
            $0.centerY.equalTo(titleLabel)
        }
        
        separator.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        bodyTextView.snp.makeConstraints {
            $0.top.equalTo(separator.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(additionalStackView.snp.top)
        }
        
        additionalStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        view.layoutIfNeeded()
        
        bodySegment.snp.makeConstraints {
            $0.width.equalTo(view.frame.width - 200)
        }
    }
}
