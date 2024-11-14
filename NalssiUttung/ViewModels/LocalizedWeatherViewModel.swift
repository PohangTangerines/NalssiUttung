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
    @Published var originalSavedLocations: [LocationInfo] = []
    @Published var deletedLocations: [LocationInfo] = []
    
    @Published var filteredLocations: [String] = []
    
    /// weatherLocationManager에 전달해주기 위한 임시 변수입니다.
    var selectedLocation: CLLocation?
    
    @Published var mode: WeatherDisplayMode = .modal

    func loadLocations() {
        self.savedLocations = coreDataStack.fetchAllLocations()
        self.originalSavedLocations = self.savedLocations
    }
    
    func saveLocation(location: LocationInfo?) {
        guard let location else { return }
        coreDataStack.saveLocation(location: location)
        loadLocations()
    }
    
    func determineWeatherDisplayMode(for location: String) {
        self.mode = coreDataStack.isLocationExist(for: location) ? .modalInList : .modal
    }
    
    func deleteLocationIfexist(for location: LocationInfo) {
        if let index = savedLocations.firstIndex(where: { $0.id == location.id }) {
            let locationToRemove = savedLocations[index]
            savedLocations.remove(at: index)
            deletedLocations.append(locationToRemove)
        }
    }
    
    func deleteLocationsInCoreData() {
        coreDataStack.deleteLocations(deletedLocations)
    }

    func move(from source: IndexSet, to destination: Int) {
        savedLocations.move(fromOffsets: source, toOffset: destination)
    }
    
    func saveOrderInCoreData() {
        for (index, locationInfo) in savedLocations.enumerated() {
            coreDataStack.updateOrder(locationInfo.address, with: index)
        }
        
        coreDataStack.save()
    }
    
    func revertChanges() {
        self.savedLocations = originalSavedLocations
    }
}
