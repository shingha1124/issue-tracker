//
//  Rx+TableView+Extension.swift
//  issueTracker
//
//  Created by seongha shin on 2022/06/14.
//

import RxCocoa
import RxRelay
import RxSwift
import UIKit

class RxUITableViewDelegateProxy: DelegateProxy<UITableView, UITableViewDelegate>, DelegateProxyType, UITableViewDelegate {
    
    fileprivate let relay = BehaviorRelay<[IndexPath: UISwipeActionsConfiguration]>(value: [:])
    
    static func registerKnownImplementations() {
        self.register { RxUITableViewDelegateProxy(parentObject: $0, delegateProxy: self) }
    }
    
    static func currentDelegate(for object: UITableView) -> UITableViewDelegate? {
        object.delegate
    }
    
    static func setCurrentDelegate(_ delegate: UITableViewDelegate?, to object: UITableView) {
        object.delegate = delegate
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        relay.value[indexPath]
    }
}

extension Reactive where Base: UITableView {
    var delegate: RxUITableViewDelegateProxy {
        RxUITableViewDelegateProxy.proxy(for: base)
    }
    
    var trailingSwipeActionsConfigurationForRowAt: Binder<[IndexPath: UISwipeActionsConfiguration]> {
        Binder(delegate) { delegate, value in
            delegate.relay.accept(value)
        }
    }
}
