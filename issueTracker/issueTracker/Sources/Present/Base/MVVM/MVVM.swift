//
//  MVVM.swift
//  airbnb
//
//  Created by seongha shin on 2022/06/07.
//

import Foundation
import RxSwift
import WeakMapTable

enum ViewMapTable {
    static var viewModels = WeakMapTable<AnyObject, Any>()
}

protocol View: AnyObject {
    associatedtype ViewModel
    
    var disposeBag: DisposeBag { get set }
    
    func bind(to viewModel: ViewModel)
}

extension View {
    private var key: String {
        String(describing: type(of: self))
    }
    
    var viewModel: ViewModel? {
        get {
            guard let viewModel = ViewMapTable.viewModels.value(forKey: self) as? ViewModel else {
                return nil
            }
            return viewModel
        } set {
            ViewMapTable.viewModels.setValue(newValue, forKey: self)
            disposeBag = DisposeBag()
            if let viewModel = newValue {
                bind(to: viewModel)
            }
        }
    }
}

protocol ViewModel: AnyObject {
    associatedtype Action
    associatedtype State

    var action: Action { get }
    var state: State { get }
}
