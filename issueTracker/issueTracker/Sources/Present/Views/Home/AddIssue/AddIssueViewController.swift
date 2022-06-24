//
//  AddIssueViewController.swift
//  issueTracker
//
//  Created by seongha shin on 2022/06/24.
//

import RxSwift
import UIKit

final class AddIssueViewController: BaseViewController, View {
    
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
        view.backgroundColor = .red
        title = "asdfasfdf"
    }
    
    override func layout() {
        
    }
}
