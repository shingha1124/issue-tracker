//
//  SplashViewController.swift
//  issueTracker
//
//  Created by seongha shin on 2022/06/13.
//

import RxAppState
import RxSwift
import UIKit

final class LoginViewController: BaseViewController, View {
    
    var disposeBag = DisposeBag()
    
    func bind(to viewModel: LoginViewModel) {
        rx.viewDidLoad
            .bind(to: viewModel.action.checkLogin)
            .disposed(by: disposeBag)
    }
    
    override func attribute() {
        view.backgroundColor = .red
    }
}
