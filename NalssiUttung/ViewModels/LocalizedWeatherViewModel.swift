//
//  LocationStore.swift
//  NalssiUttung
//
//  Created by 금가경 on 2023/10/29.
//

import SwiftUI

class LocalizedWeatherViewModel: ObservableObject {
    @ObservedObject var locationManager = LocationManager.shared
    
    // TODO: - 리스트에서 값 선택 시
    @Published var savedLocations: [String] = []
    
    func loadLocations() -> [String] {
        return UserDefaults.standard.stringArray(forKey: "locations") ?? []
    }
    
    func saveLocations(come list: [String]) {
        UserDefaults.standard.set(list, forKey: "locations")
    }
    
    func updateSavedLocations() {
        var locationList = loadLocations()
        
        // TODO: - 임시 중복방지 상태, LocationInfo 수정 후 삭제하기
        guard !locationList.contains(locationManager.selectedAddress) else { return }
        locationList.append(locationManager.selectedAddress)
        saveLocations(come: locationList)
    }
    
    func updateSelectedLocation(for address: String) {
        // TODO: - locationManager.selectedLocation 강제 언래핑 문제 해결
        let updatedLocation = locationManager.findCoordinates(address: address)
        locationManager.selectedLocation = updatedLocation
    }
    
    // MARK: - 뷰 편집 관련 함수
    func move(from source: IndexSet, to destination: Int) {
        savedLocations.move(fromOffsets: source, toOffset: destination)
        saveLocations(come: savedLocations)
    }
    
    func checkIsInList(address: String) -> WeatherDisplayMode {
        return savedLocations.contains(address) ? .modalInList : .modal
    }
}
