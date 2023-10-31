//
//  LocationStore.swift
//  NalssiUttung
//
//  Created by 금가경 on 2023/10/29.
//

import SwiftUI

class LocationStore: ObservableObject {
    @Published var selectedLocations: [String] = []
    
    func loadLocations() {
        selectedLocations = UserDefaults.standard.stringArray(forKey: "locations") ?? []
    }
    
    func saveLocations() {
        UserDefaults.standard.set(selectedLocations, forKey: "locations")
        
    }
    
    func addLocation(_ location: String) {
        loadLocations()
        selectedLocations.append(location)
        saveLocations()
    }
    
    func removeLocation() {
        if !selectedLocations.isEmpty {
            selectedLocations.removeLast()
            saveLocations()
        }
    }
    
    func moveLocation(from source: IndexSet, to destination: Int) {
        selectedLocations.move(fromOffsets: source, toOffset: destination)
        saveLocations()
    }
    
}
