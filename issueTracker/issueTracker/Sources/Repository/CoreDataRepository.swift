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
        container.loadPersistentStores(completionHandler: { storeDescription, error in
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
    
    func update<T: BaseCoreData, Entity: CoreDatable>(_ type: Entity.Type, values: [T] ) -> [T] {
        let context = persistentContainer.viewContext
    
        let fetchRequest = Entity.fetchRequest()
        fetchRequest.fetchLimit = 1
        print("---------------------------------------------------------")
        print(values[0])
        
        let updateValues = values.map { value -> T in
            fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
                NSPredicate(format: "id = %@", "\(value.id)")
            ])
            
            var updateValue = value
            
            if let findObject = try? context.fetch(fetchRequest).first,
               let coreData = findObject as? CoreDatable {
                updateValue = coreData.update(value) ?? value
                context.delete(coreData)
            }
            
            let object = Entity(context: context)
            object.setData(updateValue)
            
            return updateValue
        }
        print(updateValues[0])
        
        print("---------------------------------------------------------")
        do {
            try context.save()
        } catch {
        }
        return updateValues
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
