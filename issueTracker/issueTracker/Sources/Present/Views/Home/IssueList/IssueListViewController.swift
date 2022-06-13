//
//  IssueListViewController.swift
//  issueTracker
//
//  Created by seongha shin on 2022/06/13.
//

import RxSwift
import UIKit

final class IssueListViewController: BaseViewController, View {
    
    var disposeBag = DisposeBag()
    
    func bind(to viewModel: IssueListViewModel) {
        
    }
    
    override func attribute() {
        view.backgroundColor = .red
    }
}
