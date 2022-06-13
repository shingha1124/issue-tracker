//
//  BaseView.swift
//  airbnb
//
//  Created by seongha shin on 2022/06/07.
//

import RxSwift
import UIKit

class BaseCollectionViewCell: UICollectionViewCell {

    var disposeBag = DisposeBag()

    static var identifier: String { .init(describing: self) }

    override init(frame: CGRect) {
        super.init(frame: frame)
        attribute()
        layout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    func attribute() { }

    func layout() { }
}
