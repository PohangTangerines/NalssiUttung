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
    
    let locations = LocationInfo.Data.map { $0.address }
    
    @StateObject var weatherByLocationViewModel = WeatherByLocationViewModel()
    @State var currnetLocation: String?
    @State var searchLocation: [String]?
    
    // MARK: Modal 관련
    @State private var isSearchModalVisible = false
    @State private var isSelectedModalVisible = false
    @State private var isCurrentWeatherModalVisible = false
    
    @StateObject var toolbarViewModel = ToolbarViewModel()
    
    var filteredLocations: [String] {
        return locations.filter { $0.contains(toolbarViewModel.searchText) }
    }
    
    var body: some View {
        VStack {
            if toolbarViewModel.isTextFieldActive {
                searchBarList
            } else {
                weatherByLocationList
            }
            if toolbarViewModel.isTextFieldActive && filteredLocations == [] {
                emptyView
            }
        }
        .padding(.vertical, 20.responsibleWidth)
        .customNavigationBar(toolbarViewModel: toolbarViewModel)
        .background(Color.seaSky)
    }
    
    // TODO: - 이 뷰에서 분리
    private var searchBarList : some View {
        List {
            ForEach(filteredLocations.prefix(10), id: \.self) { filteredLocation in
                HStack {
                    if let range = filteredLocation.range(of: toolbarViewModel.searchText, options: .caseInsensitive) {
                        let beforeText = filteredLocation[..<range.lowerBound]
                        let searchText = filteredLocation[range]
                        let afterText = filteredLocation[range.upperBound...]
                        
                        Text(beforeText)
                        +
                        Text(searchText)
                            .bold()
                        +
                        Text(afterText)
                    } else {
                        Text(filteredLocation)
                    }
                }
                .onTapGesture {
                    if !isSelectedModalVisible && !isCurrentWeatherModalVisible {
                        weatherByLocationViewModel.selectedfilteredLocationForModal = filteredLocation
                        isSearchModalVisible = true
                        
                        // TODO: - locationManager.selectedLocation 강제 언래핑 문제 해결
                        let updatedLocation = locationManager.findCoordinates(address: filteredLocation)
                        locationManager.selectedLocation = updatedLocation!
                    }
                    
                }
                .sheet(isPresented: $isSearchModalVisible, content: {
                    if let searchLocation = searchLocation, (searchLocation.contains(weatherByLocationViewModel.selectedfilteredLocationForModal)) {
                        MainView(mode: .modalInList, isModalPresented: $isSearchModalVisible, isTextFieldActive: $toolbarViewModel.isTextFieldActive)
                            .onDisappear {
                                isSearchModalVisible = false
                            }
                    } else {
                        MainView(mode: .modal, isModalPresented: $isSearchModalVisible, isTextFieldActive: $toolbarViewModel.isTextFieldActive)
                            .onDisappear {
                                isSearchModalVisible = false
                            }
                    }
                    
                })
                .listRowSeparator(.hidden)
            }
            .listRowBackground(Color.seaSky)
            
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .task {
            let userList = weatherByLocationViewModel.loadLocations()
            searchLocation = userList
        }
    }
    
    // TODO: - 이 뷰에서 분리
    private var weatherByLocationList: some View {
        ScrollView {
            LazyVStack {
                currentWeatherView
                ForEach(weatherByLocationViewModel.selectedLocations, id: \.self) { selectedLocation in
                    HStack {
                        if toolbarViewModel.isEditMode {
                            Image("deleteButton")
                                .frame(maxWidth: 28, maxHeight: 28)
                                .foregroundStyle(.red)
                                .onTapGesture {
                                    if let index = weatherByLocationViewModel.selectedLocations.firstIndex(of: selectedLocation) {
                                        weatherByLocationViewModel.selectedLocations.remove(at: index)
                                        weatherByLocationViewModel.saveLocations(come: weatherByLocationViewModel.selectedLocations)
                                    }
                                }
                            Spacer()
                        }
                        WeatherCard(weatherManager: weatherManager, address: selectedLocation, isCurrentLocation: false)
                            .frame(maxWidth: .infinity, maxHeight: 140)
                            .listRowSeparator(.hidden)
                            .onTapGesture {
                                if !toolbarViewModel.isTextFieldActive {
                                    weatherByLocationViewModel.selectedLocationForModal = selectedLocation
                                    isSelectedModalVisible = true
                                }
                                let updatedLocation = locationManager.findCoordinates(address: selectedLocation)
                                // TODO: - 강제 언래핑 변경, updatedLocation이 언제 nil이 되는지 다시 확인해보기
                                locationManager.selectedLocation = updatedLocation!
                                print(updatedLocation!)
                            }
                            .sheet(isPresented: $isSelectedModalVisible) {
                                MainView(mode: .modalInList, isModalPresented: $isSelectedModalVisible)
                                    .onDisappear {
                                        isSelectedModalVisible = false
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
                    weatherByLocationViewModel.selectedLocations = userList
                    print("Success load: \(userList)")
                } catch {
                    weatherByLocationViewModel.selectedLocations = []
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
                        isCurrentWeatherModalVisible = true
                    }
                }
                .sheet(isPresented: $isCurrentWeatherModalVisible) {
                    
                    MainView(mode: .modalInList, isModalPresented: $isCurrentWeatherModalVisible)
                        .onDisappear {
                            isCurrentWeatherModalVisible = false
                            locationManager.selectedLocation = nil
                        }
                }
        }
        .listRowSeparator(.hidden)
    }
    
    func move(from source: IndexSet, to destination: Int) {
        weatherByLocationViewModel.selectedLocations.move(fromOffsets: source, toOffset: destination)
        weatherByLocationViewModel.saveLocations(come: weatherByLocationViewModel.selectedLocations)
    }
}
