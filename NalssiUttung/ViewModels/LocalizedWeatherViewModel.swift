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
                await updateSelectedAddress()
                await weatherManager.fetchWeather(with: .all)
            }
        }
    }
    
    @Published var selectedAddress: String?
    
    func isSelectedAddressSameAsCurrent(address: String?) -> Bool {
        guard let address else { return false }
        return LocationManager.shared.isDeviceLocation &&
               LocationManager.shared.currentAddress == address
    }
    
    @MainActor
    private func updateSelectedAddress() async {
        guard let selectedLocation else {
            selectedAddress = nil
            return
        }
        
        do {
            selectedAddress = try await LocationManager.shared.getAddress(from: selectedLocation)
        } catch {
            print("주소 변환 오류: \(error)")
        }
    }
    
    /// 선택된 주소를 바탕으로 localizedWeatherView의 selectedLocation을 업데이트합니다.
    /// - Parameter address: 사용자가 선택한 주소를 의미합니다.
    func updateSelectedLocation(from address: String) {
        self.selectedLocation = LocationManager.shared.findLocation(from: address)
    }
    
    @Published var mode: WeatherDisplayMode = .modalInList
    
    func loadLocations() {
        self.savedLocations = coreDataStack.fetchAllLocations()
        self.originalSavedLocations = self.savedLocations
    }
    
    func save(locationInfo: LocationInfo?) {
        coreDataStack.save(locationInfo: locationInfo)
        loadLocations()
    }
    
    /// 코어데이터에 위치가 저장되어 있지 않으면 추가 버튼을 삭제시킵니다.
    /// 현재 위치도 추가하지 못하게 막아 두었습니다.
    /// - Parameter address: adress는 주소입니다.
    func determineWeatherDisplayMode(for address: String?) {
        guard let address else {
            self.mode = .modal
            return
        }
        self.mode = (coreDataStack.isLocationExist(for: address) || isSelectedAddressSameAsCurrent(address: address)) ? .modalInList : .modal
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
