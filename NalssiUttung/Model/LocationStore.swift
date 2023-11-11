//
//  LocationStore.swift
//  NalssiUttung
//
//  Created by 금가경 on 2023/10/29.
//

import SwiftUI

class LocationStore: ObservableObject {
    @Published var selectedLocations: [String] = []
    @Published var selectedLocationForModal: String = "제주공항"
    @Published var selectedfilteredLocationForModal: String = "제주공항"
    @Published var currentLocation: String = "제주공항"
    
    func loadLocations() -> [String] {
            return UserDefaults.standard.stringArray(forKey: "locations") ?? []
    }
    
    func saveLocations(come list: [String]) {
        UserDefaults.standard.set(list, forKey: "locations")
    }
}
