//
//  MilestoneListViewController.swift
//  issueTracker
//
//  Created by 이준우 on 2022/06/20.
//

import RxCocoa
import RxRelay
import RxSwift
import UIKit

final class MilestoneListViewController: BaseViewController, View {
    
    var disposeBag = DisposeBag()
    
    func bind(to viewModel: MilestoneListViewModel) {
        
        rx.viewWillAppear
            .withUnretained(self)
            .bind(onNext: {vc, _ in
                vc.navigationController?.navigationBar.prefersLargeTitles = true
            })
            .disposed(by: disposeBag)
    }
    
    override func attribute() {
        title = "마일스톤"
        view.backgroundColor = .systemBackground
    }
}
