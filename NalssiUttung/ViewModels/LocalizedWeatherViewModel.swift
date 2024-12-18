//
//  LocationStore.swift
//  NalssiUttung
//
//  Created by 금가경 on 2023/10/29.
//

import SwiftUI
import CoreLocation

class LocalizedWeatherViewModel: ObservableObject {
    private let coreDataStack = CoreDataStack.shared
    private let weatherManager = WeatherManager()
    
    @Published var savedLocations: [LocationInfo] = []
    @Published var originalSavedLocations: [LocationInfo] = []
    @Published var deletedLocations: [LocationInfo] = []
    
    @Published var filteredLocations: [String] = []
    
    var selectedLocation: CLLocation? {
        didSet {
            Task {
                await weatherManager.fetchWeather(with: .all)
                await updateSelectedAddress()
            }
        }
    }
    @Published var selectedAddress: String?

    @MainActor
    private func updateSelectedAddress() async {
        guard let selectedLocation else { return }
        
        do {
            selectedAddress = try await LocationManager.shared.getAddress(from: selectedLocation)
        } catch {
            print("주소 변환 오류: \(error)")
        }
    }
    
    func updateSelectedLocation(for address: String) {
        if let updatedLocation = LocationManager.shared.findLocationInfo(for: address) {
            self.selectedLocation = CLLocation(latitude: updatedLocation.coordinate.latitude,
                                               longitude: updatedLocation.coordinate.longitude)
        }
    }
    
    @Published var mode: WeatherDisplayMode = .modalInList
    @Published var isCurrentLocation: Bool = true

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
}
