//
//  WeatherByLocationView.swift
//  NalssiUttung
//
//  Created by 금가경 on 11/8/24.
//

import SwiftUI
import WeatherKit

struct WeatherByLocationView: View {
    @ObservedObject var locationManager = LocationManager.shared
    @StateObject var weatherManager = WeatherManager()
    
    @StateObject var weatherByLocationViewModel = WeatherByLocationViewModel()
    @EnvironmentObject var toolbarViewModel: ToolbarViewModel

    var body: some View {
        VStack {
            if toolbarViewModel.isTextFieldActive {
                LocationSearchResultView(weatherByLocationViewModel: weatherByLocationViewModel)
            } else {
                weatherByLocationList
            }
            if toolbarViewModel.isTextFieldActive && toolbarViewModel.filteredLocations == [] {
                NoResultView()
            }
        }
        .padding(.vertical, 20.responsibleWidth)
        .customNavigationBar(toolbarViewModel: toolbarViewModel)
        .background(Color.seaSky)
    }
    
    // TODO: - 이 뷰에서 분리
    private var weatherByLocationList: some View {
        ScrollView {
            LazyVStack {
                currentWeatherView
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
                        WeatherListCardView(address: selectedLocation, isCurrentLocation: false)
                            .frame(maxWidth: .infinity, maxHeight: 140)
                            .listRowSeparator(.hidden)
                            .onTapGesture {
                                if !toolbarViewModel.isTextFieldActive {
                                    toolbarViewModel.isModalPresented = true
                                }
                                
                                // TODO: - 강제 언래핑 변경, updatedLocation이 언제 nil이 되는지 다시 확인해보기
                                let updatedLocation = locationManager.findCoordinates(address: selectedLocation)
                                locationManager.selectedLocation = updatedLocation
                                
                            }
                            .sheet(isPresented: $toolbarViewModel.isModalPresented) {
                                MainView(mode: .modalInList)
                            }
                    }
                }
                .onMove(perform: weatherByLocationViewModel.move) // 항목 이동 기능
            }
            .scrollContentBackground(.hidden)
            .environment(\.editMode, .constant(toolbarViewModel.isEditMode ? EditMode.active : EditMode.inactive))
            .task {
                do {
                    let userList = try await weatherByLocationViewModel.loadLocations()
                    weatherByLocationViewModel.savedLocations = userList
                    print("Success load: \(userList)")
                } catch {
                    weatherByLocationViewModel.savedLocations = []
                    print("task error")
                }
            }
        }
        .scrollIndicators(.hidden)
    }
    
    // TODO: - WeatherByLocationList와 통합
    private var currentWeatherView: some View {
        HStack {
            WeatherListCardView(weatherManager: weatherManager, address: locationManager.currentAddress, isCurrentLocation: true)
                .frame(maxWidth: .infinity, maxHeight: 140)
                .listRowSeparator(.hidden)
                .onTapGesture {
                    if !toolbarViewModel.isTextFieldActive {
                        toolbarViewModel.isModalPresented = true
                    }
                }
                .sheet(isPresented: $toolbarViewModel.isModalPresented) {
                    
                    MainView(mode: .modalInList)
                        .onDisappear {
                            locationManager.selectedLocation = nil
                        }
                }
        }
        .listRowSeparator(.hidden)
    }
}
