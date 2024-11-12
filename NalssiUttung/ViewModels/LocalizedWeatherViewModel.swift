//
//  LocationStore.swift
//  NalssiUttung
//
//  Created by 금가경 on 2023/10/29.
//

import SwiftUI
import CoreLocation

class LocalizedWeatherViewModel: ObservableObject {
    @ObservedObject var locationManager = LocationManager.shared
    private let coreDataStack = CoreDataStack.shared
    
    @Published var savedLocations: [LocationInfo] = []
    @Published var mode: WeatherDisplayMode = .modal

    func loadLocations() {
        self.savedLocations = coreDataStack.fetchAllLocations()
    }
    
    func saveLocation(location: LocationInfo?) {
        guard let location else { return }
        coreDataStack.saveLocation(location: location)
        loadLocations()
    }
    
    func determineWeatherDisplayMode(for location: String) {
        self.mode = coreDataStack.isLocationExist(for: location) ? .modalInList : .modal
    }
    
    func deleteLocation(at index: Int) {
        let locationToRemove = savedLocations[index]
        coreDataStack.deleteLocation(locationToRemove)
        savedLocations.remove(at: index)
    }

    func move(from source: IndexSet, to destination: Int) {
        savedLocations.move(fromOffsets: source, toOffset: destination)
        
        for (index, locationInfo) in savedLocations.enumerated() {
            coreDataStack.updateOrder(locationInfo.address, with: index)
        }
        
        coreDataStack.save()
    }
}
