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
    
    /// 코어데이터의 위치 정보를 전부 불러와 savedLocations에 저장합니다.
    func loadLocations() {
        self.savedLocations = coreDataStack.fetchAllLocations()
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
    
    /// UI에 보여주는 저장된 목록인 savedLocations 배열에서 선택한 값을 삭제합니다.
    /// 코어데이터에서 삭제하기 위해 deletedLocations에 값을 저장해둡니다.
    /// - Parameter locationInfo: 위치, 주소, 좌표 등이 들어있는 위치 전체 정보 값입니다.
    func deleteLocationIfexist(for locationInfo: LocationInfo) {
        if let index = savedLocations.firstIndex(where: { $0.id == locationInfo.id }) {
            let locationToRemove = savedLocations[index]
            savedLocations.remove(at: index)
            deletedLocations.append(locationToRemove)
            print("삭제 목록: \(deletedLocations)")
        }
    }
    
    /// 값을 모아 두었다가 코어데이터에서 한 번에 삭제합니다. 
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
