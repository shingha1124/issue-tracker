//
//  BaseViewController.swift
//  airbnb
//
//  Created by seongha shin on 2022/06/07.
//

import UIKit

class BaseViewController: UIViewController {
    
    weak var coordinator: Coordinator?
    
    init() {
        print("init \(String(describing: type(of: self)))")
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("\(#function) init(coder:) has not been implemented")
    }
    
    deinit {
        print("deinit \(String(describing: type(of: self)))")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attribute()
        layout()
    }
    
    func attribute() { }
    func layout() { }
}
