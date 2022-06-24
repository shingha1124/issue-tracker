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
    
    var disposeBag = DisposeBag()
    
    func bind(to viewModel: AddIssueViewModel) {
        rx.viewDidAppear
            .withUnretained(self)
            .bind(onNext: { vc, _ in
                vc.navigationController?.navigationBar.prefersLargeTitles = false
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
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
