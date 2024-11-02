//
//  LocationListView.swift
//  NalssiUttung
//
//  Created by CHANG JIN LEE on 2023/09/11.

import SwiftUI
import WeatherKit

struct LocationListView: View {
    @ObservedObject var locationManager = LocationManager.shared
    @StateObject var weatherManager = WeatherManager()
    
    let locations = LocationInfo.Data.map { $0.address }
    
    @StateObject var locationStore = LocationViewModel()
    @State var currnetLocation: String?
    @State var searchLocation: [String]?
    
    // MARK: SearchBar 관련
    @FocusState private var isFocused: Bool
    @State private var searchText = ""
    @State private var isEditMode = false // 삭제 모드 활성화 여부를 추적
    @State var isTextFieldActive = false
    
    // MARK: Modal 관련
    @State private var isSearchModalVisible = false
    @State private var isSelectedModalVisible = false
    @State private var isCurrentWeatherModalVisible = false
    
    var filteredLocations: [String] {
        return locations.filter { $0.contains(searchText) }
    }
    
    var body: some View {
        ZStack {
            // MARK: Weather Widgets
            if isTextFieldActive {
                searchBarList
            } else {
                selectedList
            }
            if isTextFieldActive && filteredLocations == [] {
                emptyView
            }
        }
        .overlay {
            // MARK: Navigation Bar
            NavigationBar(searchText: $searchText, isEditMode: $isEditMode, isTextFieldActive: $isTextFieldActive)
        }
    }
    private var searchBarList : some View {
        List {
            ForEach(filteredLocations.prefix(10), id: \.self) { filteredLocation in
                HStack {
                    if let range = filteredLocation.range(of: searchText, options: .caseInsensitive) {
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
                .frame(maxWidth: .infinity, maxHeight: 140, alignment: .leading)
                .contentShape(Rectangle())
                .onTapGesture {
                    if !isSelectedModalVisible && !isCurrentWeatherModalVisible {
                        locationStore.selectedfilteredLocationForModal = filteredLocation
                        isSearchModalVisible = true
                        
                        let updatedLocation = locationManager.findCoordinates(address: filteredLocation)
                        locationManager.selectedLocation = updatedLocation!
                    }
                    
                }
                .sheet(isPresented: $isSearchModalVisible, content: {
                    if let searchLocation = searchLocation, (searchLocation.contains(locationStore.selectedfilteredLocationForModal)) {
                        MainView(mode: .modalInList, isModalPresented: $isSearchModalVisible, isTextFieldActive: $isTextFieldActive)
                            .onDisappear {
                                isFocused = false
                                isSearchModalVisible = false
                            }
                    } else {
                        MainView(mode: .modal, isModalPresented: $isSearchModalVisible, isTextFieldActive: $isTextFieldActive)
                            .onDisappear {
                                isFocused = false
                                isSearchModalVisible = false
                            }
                    }
                    
                })
                .listRowSeparator(.hidden)
            }
            .listRowBackground(Color.seaSky)
        }
        .safeAreaInset(edge: .top) {
            EmptyView()
                .frame(maxHeight: 125)
        }
        .listStyle(.plain)
        .background(Color.seaSky)
        .scrollContentBackground(.hidden)
        .task {
            let userList = locationStore.loadLocations()
            searchLocation = userList
        }
    }
    
    private var selectedList: some View {
        List {
            currentWeatherView
            ForEach(locationStore.selectedLocations, id: \.self) { selectedLocation in
                HStack {
                    if isEditMode {
                        Image("deleteButton")
                            .frame(maxWidth: 28, maxHeight: 28)
                            .foregroundColor(.red)
                            .onTapGesture {
                                if let index = locationStore.selectedLocations.firstIndex(of: selectedLocation) {
                                    locationStore.selectedLocations.remove(at: index)
                                    locationStore.saveLocations(come: locationStore.selectedLocations)
                                }
                            }
                        Spacer()
                    }
                    WeatherCard(weatherManager: weatherManager, address: selectedLocation, isCurrentLocation: false)
                        .frame(maxWidth: .infinity, maxHeight: 140)
                        .listRowSeparator(.hidden)
                        .onTapGesture {
                            if !isTextFieldActive {
                                locationStore.selectedLocationForModal = selectedLocation
                                isSelectedModalVisible = true
                            }
                            let updatedLocation = locationManager.findCoordinates(address: selectedLocation)
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
                .listRowSeparator(.hidden)
            }
            .onMove(perform: move) // 항목 이동 기능
            .listRowBackground(Color.seaSky)
        }
        .safeAreaInset(edge: .top) {
            EmptyView()
                .frame(maxHeight: 125)
        }
        .listStyle(.plain)
        .background(Color.seaSky)
        .scrollContentBackground(.hidden)
        .environment(\.editMode, .constant(isEditMode ? EditMode.active : EditMode.inactive))
        .task {
            do {
                let userList = try await locationStore.loadLocations()
                locationStore.selectedLocations = userList
                print("Success load: \(userList)")
            } catch {
                locationStore.selectedLocations = []
                print("task error")
            }
        }
    }
    
    private var emptyView: some View {
        VStack {
            Image("donut")
            Text("검색 결과가 없어요")
                .font(.IMHyemin(.body))
        }
        .background(Color.seaSky)
    }
    
    private var currentWeatherView: some View {
        HStack {
            WeatherCard(weatherManager: weatherManager, address: locationManager.currentAddress, isCurrentLocation: true)
                .frame(maxWidth: .infinity, maxHeight: 140)
                .listRowSeparator(.hidden)
                .onTapGesture {
                    if !isTextFieldActive {
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
        .listRowBackground(Color.seaSky)
    }
    
    func move(from source: IndexSet, to destination: Int) {
        locationStore.selectedLocations.move(fromOffsets: source, toOffset: destination)
        locationStore.saveLocations(come: locationStore.selectedLocations)
    }
}
