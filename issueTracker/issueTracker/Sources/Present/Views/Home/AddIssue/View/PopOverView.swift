//
//  PopOverView.swift
//  issueTracker
//
//  Created by seongha shin on 2022/06/24.
//

import UIKit

final class PopOverView: UIView {

    private let title: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        attribute()
        layout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func attribute() {
        
    }
    
    private func layout() {
        addSubview(title)
        addSubview(stackView)
    }
    
    func addView(_ view: UIView) {
        stackView.addArrangedSubview(view)
    }
}
