//
//  CDInssue+CoreDataProperties.swift
//  
//
//  Created by seongha shin on 2022/06/16.
//
//

import Foundation
import CoreData

extension CDInssue: CoreDatable {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDInssue> {
        return NSFetchRequest<CDInssue>(entityName: "CDInssue")
    }

    @NSManaged public var id: Int64
    @NSManaged public var updatedAt: Date
    @NSManaged public var state: String

    func setData<T>(_ data: T) where T : BaseCoreData {
        guard let data = data as? Issue else {
            return
        }
        id = Int64(data.id)
        updatedAt = data.updatedAt
        state = data.state.value
    }
    
    func update<T>(_ data: T) -> T? where T: BaseCoreData {
        guard let data = data as? Issue else {
            return data
        }
        
        if updatedAt > data.updatedAt {
            let state = Issue.State.init(rawValue: state) ?? data.state
            return Issue(id: data.id, number: data.number, title: data.title, body: data.body, state: state, updatedAt: updatedAt, labels: data.labels, milestone: data.milestone) as? T
        }
        return data as? T
    }
}
