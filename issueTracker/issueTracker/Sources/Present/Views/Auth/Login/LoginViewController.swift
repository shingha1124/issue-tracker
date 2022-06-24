//
//  SplashViewController.swift
//  issueTracker
//
//  Created by seongha shin on 2022/06/13.
//

import RxAppState
import RxSwift
import SnapKit
import UIKit

final class LoginViewController: BaseViewController, View {
    
    private let gitLoginButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .black
        config.image = UIImage(named: "ic_github")
        config.imagePadding = 8
        config.imagePlacement = .leading
        config.title = "Sign in with Github".localized()
        config.cornerStyle = .medium
        let button = UIButton(configuration: config)
        return button
    }()
    
    var disposeBag = DisposeBag()
    
    func bind(to viewModel: LoginViewModel) {
        gitLoginButton.rx.tap
            .bind(to: viewModel.action.tappedGitLogin)
            .disposed(by: disposeBag)
    }
    
    override func attribute() {
        view.backgroundColor = .backGround2
    }
    
    override func layout() {
        view.addSubview(gitLoginButton)
        
        gitLoginButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(56)
        }
    }
}
