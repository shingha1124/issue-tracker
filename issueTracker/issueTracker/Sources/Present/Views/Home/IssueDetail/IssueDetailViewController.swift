//
//  IssueDetailViewController.swift
//  issueTracker
//
//  Created by 이준우 on 2022/06/28.
//

import RxCocoa
import RxSwift
import UIKit

final class IssueDetailViewController: BaseViewController, View {
    
    var disposeBag: DisposeBag = DisposeBag()

    func bind(to viewModel: IssueDetailViewModel) {
        
        rx.viewDidAppear
            .withUnretained(self)
            .bind(onNext: { vc, _ in
                vc.view.backgroundColor = .lightGray
            })
    }
}
