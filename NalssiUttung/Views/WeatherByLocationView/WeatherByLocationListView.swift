//
//  WeatherByLocationListView.swift
//  NalssiUttung
//
//  Created by 금가경 on 11/8/24.
//

import SwiftUI

struct WeatherByLocationListView: View {
    @ObservedObject var locationManager = LocationManager.shared
    @StateObject var weatherManager = WeatherManager()
    
    @ObservedObject var weatherByLocationViewModel: WeatherByLocationViewModel
    @EnvironmentObject var toolbarViewModel: ToolbarViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack {
                WeatherListCardView(weatherManager: weatherManager, address: locationManager.currentAddress, isCurrentLocation: true, mode: .modalInList)
                
                ForEach(weatherByLocationViewModel.savedLocations, id: \.self) { selectedLocation in
                    HStack {
                        if toolbarViewModel.isEditMode {
                            Image("deleteButton")
                                .frame(maxWidth: 28, maxHeight: 28)
                                .foregroundStyle(.red)
                                .onTapGesture {
                                    if let index = weatherByLocationViewModel.savedLocations.firstIndex(of: selectedLocation) {
                                        weatherByLocationViewModel.savedLocations.remove(at: index)
                                        weatherByLocationViewModel.saveLocations(come: weatherByLocationViewModel.savedLocations)
                                    }
                                }
                            Spacer()
                        }
                        WeatherListCardView(address: selectedLocation, isCurrentLocation: false, mode: .modalInList)
                    }
                }
                .onMove(perform: weatherByLocationViewModel.move) // 항목 이동 기능
            }
            .environment(\.editMode, .constant(toolbarViewModel.isEditMode ? EditMode.active : EditMode.inactive))
            .task {
                let userList = weatherByLocationViewModel.loadLocations()
                weatherByLocationViewModel.savedLocations = userList
            }
        }
    }
}
