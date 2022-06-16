//
//  LoginButtonView.swift
//  issueTracker
//
//  Created by seongha shin on 2022/06/14.
//

import UIKit

final class LoginButtonView: BaseView {
    
    private let icon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ic_github")
        return imageView
    }()
    
    private let title: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        return label
    }()
    
    var image: UIImage? {
        didSet {
            icon.image = image
        }
    }
    
    var text: String? {
        didSet {
            title.text = text
        }
    }
    
    override func attribute() {
        backgroundColor = .black
    }
    
    override func layout() {
    }
}
