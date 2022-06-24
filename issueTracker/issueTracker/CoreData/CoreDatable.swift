//
//  CoreDatable.swift
//  issueTracker
//
//  Created by seongha shin on 2022/06/16.
//

import CoreData
import Foundation

protocol CoreDatable: NSManagedObject {
    var id: Int64 { get }
    func setData<T: BaseCoreData>(_ data: T)
    func fetch<T: BaseCoreData>(_ data: T) -> T?
}
