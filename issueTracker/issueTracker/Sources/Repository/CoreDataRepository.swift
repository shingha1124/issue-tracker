//
//  CoreDataProvider.swift
//  issueTracker
//
//  Created by seongha shin on 2022/06/15.
//

import CoreData
import Foundation
import RxSwift

class CoreDataRepository {
    /*
     NSManagedObjectModel: Managed Objects의 structure를 정의
     NSPersistentStoreCoordinator: persistent storage(영구저장소)와 ManagedObjectModel을 연결
     NSManagedObjectContext: Managed Object를 생성하고, 저장하고, 가져오는 동작 제공
     NSPersistentContainer: CoreDataStack을 나타내는 필요한 모든객체를 포함
     */
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetch<T: BaseCoreData, Entity: CoreDatable>(_ type: Entity.Type, values: [T] ) -> [T] {
        let context = persistentContainer.viewContext
    
        let updateValues = values.map { value -> T in

            let predicate = NSPredicate(format: "id = %@", "\(value.id)")
            
            var fetchValue = value
            if let coreData = searchObject(type, predicates: [predicate]) {
                fetchValue = coreData.fetch(value) ?? value
                context.delete(coreData)
                
                let object = Entity(context: context)
                object.setData(fetchValue)
            }
            return fetchValue
        }
        
        do {
            try context.save()
        } catch {
            Log.error(error.localizedDescription)
        }
        return updateValues
    }
    
    func update<T: BaseCoreData, Entity: CoreDatable>(_ type: Entity.Type, value: T) {
        let context = persistentContainer.viewContext
    
        let predicate = NSPredicate(format: "id = %@", "\(value.id)")
        
        if let coreData = searchObject(type, predicates: [predicate]) {
             context.delete(coreData)
        }
        
        let object = Entity(context: context)
        object.setData(value)
        
        do {
            try context.save()
        } catch {
            Log.error(error.localizedDescription)
        }
    }
    
    private func searchObject<Entity: CoreDatable>(_ type: Entity.Type, predicates: [NSPredicate]) -> CoreDatable? {
        let context = persistentContainer.viewContext
        
        let fetchRequest = Entity.fetchRequest()
        fetchRequest.fetchLimit = 1
        
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        
        if let findObject = try? context.fetch(fetchRequest).first,
           let coreData = findObject as? CoreDatable {
            return coreData
        }
        return nil
    }
}

enum CoreDataEntity {
    case issue
    
    var name: String {
        switch self {
        case .issue:
            return "CDIssue"
        }
    }
    
    var objectType: NSManagedObject.Type {
        switch self {
        case .issue:
            return CDInssue.self
        }
    }
}
