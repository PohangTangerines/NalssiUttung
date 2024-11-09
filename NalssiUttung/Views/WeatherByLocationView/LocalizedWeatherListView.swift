//
//  LocalizedWeatherListView.swift
//  NalssiUttung
//
//  Created by 금가경 on 11/8/24.
//

import SwiftUI

struct LocalizedWeatherListView: View {
    @ObservedObject var locationManager = LocationManager.shared
    @StateObject var weatherManager = WeatherManager()
    
    @ObservedObject var localizedWeatherViewModel: LocalizedWeatherViewModel
    @EnvironmentObject var toolbarViewModel: ToolbarViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack {
                WeatherListCardView(weatherManager: weatherManager, address: locationManager.currentAddress, isCurrentLocation: true, mode: .modalInList)
                
                ForEach(localizedWeatherViewModel.savedLocations, id: \.self) { selectedLocation in
                    HStack {
                        if toolbarViewModel.isEditMode {
                            Image("deleteButton")
                                .frame(maxWidth: 28, maxHeight: 28)
                                .foregroundStyle(.red)
                                .onTapGesture {
                                    if let index = localizedWeatherViewModel.savedLocations.firstIndex(of: selectedLocation) {
                                        localizedWeatherViewModel.savedLocations.remove(at: index)
                                        localizedWeatherViewModel.saveLocations(come: localizedWeatherViewModel.savedLocations)
                                    }
                                }
                            Spacer()
                        }
                        WeatherListCardView(address: selectedLocation, isCurrentLocation: false, mode: .modalInList)
                    }
                }
                .onMove(perform: localizedWeatherViewModel.move) // 항목 이동 기능
            }
            .environment(\.editMode, .constant(toolbarViewModel.isEditMode ? EditMode.active : EditMode.inactive))
            .task {
                let userList = localizedWeatherViewModel.loadLocations()
                localizedWeatherViewModel.savedLocations = userList
            }
        }
    }
}
