//
//  LocationStore.swift
//  NalssiUttung
//
//  Created by 금가경 on 2023/10/29.
//

import SwiftUI

class LocationStore: ObservableObject {
    @Published var selectedLocations: [String] = []
    @Published var selectedLocationForModal: String = "제주시 용담동"
    @Published var selectedfilteredLocationForModal: String = "제주시 용담동"
    @Published var currentLocation: String = "제주시 용담동"
    
    func loadLocations() async -> [String] {
        do{
            if let userDefaultsList = try? await UserDefaults.standard.stringArray(forKey: "locations") ?? []{
                return userDefaultsList
            } else{
                print("fail load data")
            }
        } catch{
            print("UserDefaults error: \(error.localizedDescription)")
        }
    }
    
    func saveLocations(come list: [String]) {
        UserDefaults.standard.set(list, forKey: "locations")
    }
    
//    func addLocation(_ location: String) {
//        selectedLocations = UserDefaults.standard.stringArray(forKey: "locations") ?? []
//        selectedLocations.append(location)
//        saveLocations()
//    }
//    
//    func removeLocation(at index: Int) {
//        selectedLocations.remove(at: index)
//        saveLocations()
//    }
//    
//    func moveLocation(from source: IndexSet, to destination: Int) {
//        selectedLocations.move(fromOffsets: source, toOffset: destination)
//        saveLocations()
//    }
    
}
