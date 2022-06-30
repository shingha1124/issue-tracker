//
//  SheetViewController.swift
//  issueTracker
//
//  Created by seongha shin on 2022/06/30.
//

import RxSwift
import UIKit

final class IssueDetailController: BaseViewController, View {
    
    let titleView: UIView = {
        let view = UIView()
        
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "이슈 상세 정보"
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        return label
    }()
    
    let itemStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    
    var disposeBag = DisposeBag()
    
    func bind(to viewModel: IssueDetailModel) {
    }
    
    override func attribute() {
        view.backgroundColor = .backGround2
//        sheetPresentationController?.detents = [.medium(), .large()]
    }
    
    override func layout() {
        view.addSubview(titleView)
        titleView.addSubview(titleLabel)
        
        titleView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalToSuperview().offset(21)
            $0.bottom.equalTo(titleLabel)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.top.equalToSuperview()
        }
        
        let dentent: UISheetPresentationController.Detent = ._detent(withIdentifier: "asdf", constant: 100.0)
        sheetPresentationController?.detents = [dentent, .medium(), .large()]
    }
}
