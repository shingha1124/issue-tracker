//
//  BaseView.swift
//  airbnb
//
//  Created by seongha shin on 2022/06/08.
//

import UIKit

class BaseView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        attribute()
        layout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func attribute() { }
    func layout() { }
}
