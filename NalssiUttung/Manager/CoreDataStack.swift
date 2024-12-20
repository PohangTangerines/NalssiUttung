//
//  CoreDataStack.swift
//  NalssiUttung
//
//  Created by 금가경 on 11/11/24.
//

import CoreData
import SwiftUI

class CoreDataStack: ObservableObject {
    static let shared = CoreDataStack()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "LocationInfoModel")
        container.loadPersistentStores { _, error in
            if let error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    let entityName: String = "LocationInfoEntity"
    
    func save() {
        if context.hasChanges {
            do {
                try context.save()
                print("Changes saved successfully!")
            } catch {
                print("Failed to save context: \(error.localizedDescription)")
            }
        }
    }
    
    private init() {}
}

extension CoreDataStack {
    func save(locationInfo: LocationInfo?) {
        guard let locationInfo else {
            print("저장할 위치 정보가 없습니다.")
            return
        }
        
        let locationEntity = NSEntityDescription.insertNewObject(forEntityName: entityName, into: context)
        let count = count()
        
        let locationValues: [String: Any] = [
            "name": locationInfo.name,
            "address": locationInfo.address,
            "latitude": locationInfo.coordinate.latitude,
            "longitude": locationInfo.coordinate.longitude,
            "order": count
        ]
        
        for (key, value) in locationValues {
            locationEntity.setValue(value, forKey: key)
        }
        
        save()
    }
    
    func fetchAllLocations() -> [LocationInfo] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        
        let sortDescriptor = NSSortDescriptor(key: "order", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            let result = try context.fetch(fetchRequest)
            return result.map {
                LocationInfo(
                    name: $0.value(forKey: "name") as? String ?? "",
                    address: $0.value(forKey: "address") as? String ?? "",
                    coordinate: Coordinate(latitude: $0.value(forKey: "latitude") as? Double ?? 0.0,
                                           longitude: $0.value(forKey: "longitude") as? Double ?? 0.0)
                )
            }
        } catch {
            print("Failed to fetch locations: \(error.localizedDescription)")
            return []
        }
    }
    
    func isLocationExist(for address: String) -> Bool {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "address == %@", address)
        
        do {
            let results = try context.fetch(fetchRequest)
            return !results.isEmpty
        } catch {
            print("Failed to fetch LocationInfo: \(error.localizedDescription)")
            return false
        }
    }
    
    func deleteLocations(_ locations: [LocationInfo]) {
        
        let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: entityName)
        let addresses = locations.map { $0.address }

        fetchRequest.predicate = NSPredicate(format: "address IN %@", addresses)
        
        do {
            let results = try context.fetch(fetchRequest)
            
            if let result = results.first {
                context.delete(result)
            }
        } catch {
            print("Failed to delete LocationInfo: \(error.localizedDescription)")
        }
        
        save()
    }
    
    func count() -> Int {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entityName)
        
        do {
            let results = try context.fetch(fetchRequest)
            return results.count
        } catch {
            print("Failed to fetch LocationInfo: \(error.localizedDescription)")
            return 0
        }
    }
    
    func updateOrder(_ address: String, with index: Int) {
        let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "address == %@", address)
        
        do {
            let results = try context.fetch(fetchRequest)
            if let object = results.first {
                object.setValue(index, forKey: "order")
            }
        } catch {
            print("Failed to update order.")
        }
    }

    #if DEBUG
    func clearAllLocations() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(batchDeleteRequest)
            print("Successfully deleted all data for entity")
        } catch {
            print("Failed to delete all data for entity")
        }
    }
    #endif
}
