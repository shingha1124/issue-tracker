//
//  SplashViewController.swift
//  issueTracker
//
//  Created by seongha shin on 2022/06/14.
//

import Foundation
import RxSwift

final class SplashViewController: BaseViewController, View {
    
    var disposeBag = DisposeBag()
    
    func bind(to viewModel: SplashViewModel) {
        rx.viewDidLoad
            .bind(to: viewModel.action.checkToken)
            .disposed(by: disposeBag)
    }
    
    override func attribute() {
        view.backgroundColor = .white
    }
    
    override func layout() {
        
    }
}
