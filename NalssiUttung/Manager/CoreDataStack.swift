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
    func saveLocation(location: LocationInfo?) {
        guard let location else {
            print("No location to save.")
            return
        }
        
        let locationEntity = NSEntityDescription.insertNewObject(forEntityName: entityName, into: context)
        
        let locationValues: [String: Any] = [
            "name": location.name,
            "address": location.address,
            "latitude": location.latitude,
            "longitude": location.longitude
        ]
        
        for (key, value) in locationValues {
            locationEntity.setValue(value, forKey: key)
        }
        
        save()
    }
    
    func fetchAllLocations() -> [LocationInfo] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        
        do {
            let result = try context.fetch(fetchRequest)
            return result.map {
                LocationInfo(
                    name: $0.value(forKey: "name") as? String ?? "",
                    address: $0.value(forKey: "address") as? String ?? "",
                    latitude: $0.value(forKey: "latitude") as? Double ?? 0.0,
                    longitude: $0.value(forKey: "longitude") as? Double ?? 0.0
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
    
    func deleteLocation(_ location: LocationInfo) {
        let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "address == %@", location.address)
        
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
