//
//  Inject.swift
//  Starbucks
//
//  Created by seongha shin on 2022/05/11.
//

import Foundation

@propertyWrapper
struct Inject<T> {
    
    let wrappedValue: T
    
    init(_ keyPath: KeyPath<Container, T>) {
        let container = Container.shared
        wrappedValue = container[keyPath: keyPath]
    }
}
