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
    
    /// 코어데이터에 위치가 저장되어 있지 않으면 추가 버튼을 삭제시킵니다.
    /// 현재 위치도 추가하지 못하게 막아 두었습니다.
    /// - Parameter address: adress는 주소입니다.
    func determineWeatherDisplayMode(for address: String) {
        self.mode = (coreDataStack.isLocationExist(for: address) || isCurrentLocation) ? .modalInList : .modal
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
