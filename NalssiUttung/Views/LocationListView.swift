//
//  LocationListView.swift
//  NalssiUttung
//
//  Created by CHANG JIN LEE on 2023/09/11.

import SwiftUI
import WeatherKit


struct LocationListView: View {
    @State var cardWeatherBoxData: WeatherBoxData?
    @Binding var weatherBoxData: WeatherBoxData?
    @ObservedObject var locationManager = LocationManager.shared
    
    let weatherManager = WeatherService.shared
    let locations = LocationInfo.Data.map { $0.address }
    
    @ObservedObject var locationStore: LocationStore
    
    // MARK: SearchBar 관련
    @FocusState private var isFocused: Bool
    @State private var searchText = ""
    @State var isTextFieldActive = false
    @State var isEditMode = false // 삭제 모드 활성화 여부를 추적
    
    // MARK: Modal 관련
    @State private var isSearchModalVisible = false
    
    var filteredLocations: [String] {
        return locations.filter { $0.contains(searchText) }
    }
    
    var body: some View {
        ZStack {
            // MARK: Weather Widgets
            if isTextFieldActive {
                searchBarList
            } else {
                SelectedList(locationStore: locationStore, isTextFieldActive: $isTextFieldActive, searchText: $searchText, isEditMode: $isEditMode)
            }
            if isTextFieldActive && filteredLocations == [] {
                emptyView
            }
        }
        .overlay {
            // MARK: Navigation Bar
            NavigationBar(searchText: $searchText, isEditMode: $isEditMode, isTextFieldActive: $isTextFieldActive, isFocused: _isFocused)
        }
    }
    private var searchBarList : some View {
        List {
            ForEach(filteredLocations, id: \.self) { filteredLocation in
                HStack {
                    LocationCard(weatherBoxData: $cardWeatherBoxData, location: filteredLocation, isCurrentLocation: .constant(false))
                        .frame(maxWidth: .infinity, maxHeight: 140)
                        .listRowSeparator(.hidden)
                        .onTapGesture {
                            print(filteredLocation)
                            locationStore.selectedfilteredLocationForModal = filteredLocation
                            isSearchModalVisible.toggle()
                        }
                        .sheet(isPresented: $isSearchModalVisible, content: {
                            // 새로운 뷰 표시
                            CardModalView(modalState: ModalState.isModalViewAndNotContainedContent, isModalVisible: $isSearchModalVisible, location: locationStore.selectedfilteredLocationForModal, searchText : $searchText, isFocused: _isFocused, isTextFieldActive: $isTextFieldActive, isEditMode: .constant(false))
                                .onDisappear(){
                                    isFocused = false
                                }
                        })
                        .task {
                            if let weatherData = await weatherManager.getWeatherInfoForAddress(address: filteredLocation) {
                                self.cardWeatherBoxData = weatherData
                            } else {
                                print("날씨 정보를 가져오지 못했습니다.")
                            }
                        }
                }
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
    }
    private var emptyView: some View{
        VStack {
            Image("donut")
            Text("검색 결과가 없어요")
                .font(.IMHyemin(.body))
        }
        .background(Color.seaSky)
    }
    
}


struct SelectedList: View {
    @ObservedObject var locationStore: LocationStore
    @State var cardWeatherBoxData: WeatherBoxData?
    @Binding var isTextFieldActive: Bool
    @Binding var searchText: String
    @Binding var isEditMode: Bool // 삭제 모드 활성화 여부를 추적
    @State private var isSelectedModalVisible = false
    @State private var isCurrentWeatherModalVisible = false
    @FocusState private var isFocused: Bool
    
    @ObservedObject var locationManager = LocationManager.shared
    let weatherManager = WeatherService.shared
    
    var body: some View{
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
                                    locationStore.removeLocation(at: index)
                                }
                            }
                        Spacer()
                    }
                    LocationCard(weatherBoxData: $cardWeatherBoxData, location: selectedLocation, isCurrentLocation: .constant(false))
                        .frame(maxWidth: .infinity, maxHeight: 140)
                        .listRowSeparator(.hidden)
                        .onTapGesture {
                            locationStore.selectedLocationForModal = selectedLocation
                            isSelectedModalVisible.toggle()
                        }
                        .sheet(isPresented: $isSelectedModalVisible, content: {
                            CardModalView(modalState: ModalState.isModalViewAndContainedContent, isModalVisible: $isSelectedModalVisible, location: locationStore.selectedLocationForModal, searchText : $searchText, isFocused: _isFocused, isTextFieldActive: $isTextFieldActive, isEditMode: $isEditMode)
                        })
                        .task {
                            if let weatherData = await weatherManager.getWeatherInfoForAddress(address: selectedLocation) {
                                self.cardWeatherBoxData = weatherData
                            } else {
                                print("날씨 정보를 가져오지 못했습니다.")
                            }
                        }
                        .onAppear(){
                            print(selectedLocation)
                        }
                }
                .listRowSeparator(.hidden)
            }
            .onMove(perform: locationStore.moveLocation) // 항목 이동 기능
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
        .onAppear() {
            locationStore.loadLocations()
            print(locationStore.selectedLocations)
        }
    }
    
    private var currentWeatherView: some View{
        HStack{
            LocationCard(weatherBoxData: $cardWeatherBoxData, location: locationManager.address, isCurrentLocation: .constant(true))
                .frame(maxWidth: .infinity, maxHeight: 140)
                .listRowSeparator(.hidden)
                .onTapGesture {
                    isCurrentWeatherModalVisible.toggle()
                }
                .sheet(isPresented: $isCurrentWeatherModalVisible, content: {
                    CardModalView(modalState: ModalState.isModalViewAndContainedContent, isModalVisible: $isCurrentWeatherModalVisible, location: locationManager.address, searchText : $searchText, isFocused: _isFocused, isTextFieldActive: $isTextFieldActive, isEditMode: $isEditMode)
                })
                .task {
                    if let weatherData = await weatherManager.getWeatherInfoForAddress(address: locationManager.address) {
                        self.cardWeatherBoxData = weatherData
                    } else {
                        print("날씨 정보를 가져오지 못했습니다.")
                    }
                }
        }
        .listRowSeparator(.hidden)
        .listRowBackground(Color.seaSky)
    }
}
