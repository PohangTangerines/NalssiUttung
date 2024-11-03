//
//  LocationListView.swift
//  NalssiUttung
//
//  Created by CHANG JIN LEE on 2023/09/11.

import SwiftUI
import WeatherKit

struct WeatherByLocationView: View {
    @ObservedObject var locationManager = LocationManager.shared
    @StateObject var weatherManager = WeatherManager()
    
    @StateObject var weatherByLocationViewModel = WeatherByLocationViewModel()
    @StateObject var toolbarViewModel = ToolbarViewModel()
        
    @State var currnetLocation: String?
    
    var body: some View {
        VStack {
            if toolbarViewModel.isTextFieldActive {
                LocationSearchResultView(
                    toolbarViewModel: toolbarViewModel,
                    weatherByLocationViewModel: weatherByLocationViewModel
                    )
            } else {
                weatherByLocationList
            }
            if toolbarViewModel.isTextFieldActive && toolbarViewModel.filteredLocations == [] {
                emptyView
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
                        WeatherCard(weatherManager: weatherManager, address: selectedLocation, isCurrentLocation: false)
                            .frame(maxWidth: .infinity, maxHeight: 140)
                            .listRowSeparator(.hidden)
                            .onTapGesture {
                                if !toolbarViewModel.isTextFieldActive {
                                    weatherByLocationViewModel.isModalPresented = true
                                }
                                let updatedLocation = locationManager.findCoordinates(address: selectedLocation)
                                // TODO: - 강제 언래핑 변경, updatedLocation이 언제 nil이 되는지 다시 확인해보기
                                locationManager.selectedLocation = updatedLocation!
                                print(updatedLocation!)
                            }
                            .sheet(isPresented: $weatherByLocationViewModel.isModalPresented) {
                                MainView(mode: .modalInList, isModalPresented: $weatherByLocationViewModel.isModalPresented)
                                    .onDisappear {
                                        weatherByLocationViewModel.isModalPresented = false
                                    }
                            }
                    }
                }
                .onMove(perform: move) // 항목 이동 기능
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
    }
    
    // TODO: - 이 뷰에서 분리
    // TODO: - 뷰 살짝 위로 올리기
    private var emptyView: some View {
        VStack {
            Image("donut")
            Text("검색 결과가 없어요")
                .font(.IMHyemin(.body))
            Spacer()
        }
        .padding(.bottom, 30)
        .background(Color.seaSky)
    }
    
    // TODO: - WeatherByLocationList와 통합
    private var currentWeatherView: some View {
        HStack {
            WeatherCard(weatherManager: weatherManager, address: locationManager.currentAddress, isCurrentLocation: true)
                .frame(maxWidth: .infinity, maxHeight: 140)
                .listRowSeparator(.hidden)
                .onTapGesture {
                    if !toolbarViewModel.isTextFieldActive {
                        weatherByLocationViewModel.isModalPresented = true
                    }
                }
                .sheet(isPresented: $weatherByLocationViewModel.isModalPresented) {
                    
                    MainView(mode: .modalInList, isModalPresented: $weatherByLocationViewModel.isModalPresented)
                        .onDisappear {
                            weatherByLocationViewModel.isModalPresented = false
                            locationManager.selectedLocation = nil
                        }
                }
        }
        .listRowSeparator(.hidden)
    }
    
    func move(from source: IndexSet, to destination: Int) {
        weatherByLocationViewModel.savedLocations.move(fromOffsets: source, toOffset: destination)
        weatherByLocationViewModel.saveLocations(come: weatherByLocationViewModel.savedLocations)
    }
}
