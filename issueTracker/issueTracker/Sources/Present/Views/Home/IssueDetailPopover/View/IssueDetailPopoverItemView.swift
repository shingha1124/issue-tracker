//
//  IssueDetailPopoverItemView.swift
//  issueTracker
//
//  Created by seongha shin on 2022/06/30.
//

import RxSwift
import UIKit

final class IssueDetailPopoverItemView: BaseView, View {
    
    private let title: UILabel = {
        let label = UILabel()
        label.contentMode = .left
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = .grey1
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private let icon: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    var disposeBag = DisposeBag()
    
    func bind(to viewModel: IssueDetailPopoverItemViewModel) {
        viewModel.state.title
            .bind(to: title.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.state.description
            .compactMap { $0 }
            .bind(to: descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.state.description
            .map { $0 == nil }
            .bind(to: descriptionLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.state.icon
            .compactMap { $0 }
            .map { name -> UIImage? in
                let config = UIImage.SymbolConfiguration(pointSize: 25, weight: .semibold, scale: .small)
                var image = UIImage(systemName: name, withConfiguration: config)
                image = image?.withTintColor(.black, renderingMode: .alwaysOriginal)
                return image
            }
            .bind(to: icon.rx.image)
            .disposed(by: disposeBag)
        
        viewModel.state.icon
            .map { $0 == nil }
            .bind(to: icon.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.action.loadInfo.accept(())
    }
    
    override func attribute() {
        backgroundColor = .white
    }
    
    override func layout() {
        addSubview(title)
        addSubview(descriptionLabel)
        addSubview(icon)
        
        title.snp.makeConstraints {
            $0.top.equalToSuperview().offset(11)
            $0.leading.equalToSuperview().offset(20)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.leading.equalTo(snp.centerX)
            $0.centerY.equalToSuperview()
        }
        
        icon.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
        
        snp.makeConstraints {
            $0.bottom.equalTo(title).offset(11)
        }
    }
}
