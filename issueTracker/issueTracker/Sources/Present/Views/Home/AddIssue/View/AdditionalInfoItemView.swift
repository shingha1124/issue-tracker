//
//  additionalInfoItemView.swift
//  issueTracker
//
//  Created by seongha shin on 2022/06/24.
//

import RxSwift
import UIKit

final class AdditionalInfoItemView: BaseView, View {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = .black
        return label
    }()
    
    private let targetLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = .grey1
        return label
    }()
    
    private let selectButton: UIButton = {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .light, scale: .small)
        var image = UIImage(systemName: "chevron.right", withConfiguration: imageConfig)
        image = image?.withTintColor(.grey3, renderingMode: .alwaysOriginal)
        
        let button = UIButton()
        button.setImage(image, for: .normal)
        return button
    }()
    
    var disposeBag = DisposeBag()
    
    func bind(to viewModel: AdditionalInfoItemViewModel) {
        viewModel.state.title
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        selectButton.rx.tap
            .bind(to: viewModel.action.tappedItem)
            .disposed(by: disposeBag)
        
        viewModel.state.target
            .bind(to: targetLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.action.loadData.accept(())
    }
    
    override func attribute() {
        
    }
    
    override func layout() {
        addSubview(titleLabel)
        addSubview(targetLabel)
        addSubview(selectButton)
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.top.equalToSuperview().offset(11)
        }
        
        selectButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-16)
            $0.centerY.equalTo(titleLabel)
            $0.width.height.equalTo(30)
        }
        
        targetLabel.snp.makeConstraints {
            $0.trailing.equalTo(selectButton.snp.leading).offset(4)
            $0.centerY.equalTo(titleLabel)
        }
        
        snp.makeConstraints {
            $0.bottom.equalTo(titleLabel).offset(11)
        }
    }
}
