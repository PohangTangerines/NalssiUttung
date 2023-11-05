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
    
    let weatherManager = WeatherService.shared
    let locations = LocationInfo.Data.map { $0.address }
    
    @State var locationData: [String] = UserDefaults.standard.stringArray(forKey: "location") ?? []
    @ObservedObject var locationStore: LocationStore
    
    // MARK: SearchBar 관련
    @FocusState private var isFocused: Bool
    @State private var searchText = ""
    @State private var isEditMode = false // 삭제 모드 활성화 여부를 추적
    @State var isTextFieldActive = false
    
    // MARK: Modal 관련
    @State private var isModalVisible = false
    @State var modalState: ModalState = .isModalViewAndNotContainedContent
    
    var filteredLocations: [String] {
        return locations.filter { $0.contains(searchText) }
    }
    
    var body: some View {
        ZStack {
            // MARK: Weather Widgets
            List {
                if isTextFieldActive {
                    ForEach(filteredLocations, id: \.self) { filteredLocation in
                        HStack {
                            LocationCard(weatherBoxData: $cardWeatherBoxData, location: filteredLocation, isCurrentLocation: .constant(false))
                                .frame(maxWidth: .infinity, maxHeight: 140)
                                .listRowSeparator(.hidden)
                                .onTapGesture {
                                    isModalVisible.toggle()
                                    isTextFieldActive.toggle()
                                }
                                .sheet(isPresented: $isModalVisible, content: {
                                    // 새로운 뷰 표시
                                    CardModalView(modalState: $modalState, isModalVisible: $isModalVisible, location: filteredLocation, searchText : $searchText)
                                        .onDisappear {
                                            isFocused = false
                                            isTextFieldActive = false
                                        }
                                })
                                .task {
                                    if let weatherData = await weatherManager.getWeatherInfoForAddress(address: filteredLocation) {
                                        self.cardWeatherBoxData = weatherData
                                        print(self.cardWeatherBoxData)
                                        print("현재 온도: \(weatherData.currentTemperature)°C")
                                        print("최고 온도: \(weatherData.highestTemperature)°C")
                                        print("최저 온도: \(weatherData.lowestTemperature)°C")
                                        print("날씨 상태: \(weatherData.weatherCondition)")
                                    } else {
                                        print("날씨 정보를 가져오지 못했습니다.")
                                    }
                                }
                        }
                        .listRowSeparator(.hidden)
                    }
                    .listRowBackground(Color.seaSky)
                } else {
                    ForEach(locationStore.selectedLocations, id: \.self) { selectedLocation in
                        HStack {
                            if isEditMode {
                                Image("deleteButton")
                                    .frame(maxWidth: 28, maxHeight: 28)
                                    .foregroundColor(.red)
                                    .onTapGesture {
                                        if let index = locationStore.selectedLocations.firstIndex(of: selectedLocation) {
                                            locationStore.selectedLocations.remove(at: index)
                                        }
                                    }
                                Spacer()
                            }
                            LocationCard(weatherBoxData: $cardWeatherBoxData, location: selectedLocation, isCurrentLocation: .constant(false))
                                .frame(maxWidth: .infinity, maxHeight: 140)
                                .listRowSeparator(.hidden)
                                .onTapGesture {
                                    isModalVisible.toggle()
                                }
                                .sheet(isPresented: $isModalVisible, content: {
                                    // 새로운 뷰 표시
                                    CardModalView(modalState: $modalState, isModalVisible: $isModalVisible, location: selectedLocation, searchText : $searchText)
                                })
                                .task {
                                    if let weatherData = await weatherManager.getWeatherInfoForAddress(address: selectedLocation) {
                                        self.cardWeatherBoxData = weatherData
                                        print(self.cardWeatherBoxData)
                                        print("현재 온도: \(weatherData.currentTemperature)°C")
                                        print("최고 온도: \(weatherData.highestTemperature)°C")
                                        print("최저 온도: \(weatherData.lowestTemperature)°C")
                                        print("날씨 상태: \(weatherData.weatherCondition)")
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
            }
            if isTextFieldActive && filteredLocations == [] {
                VStack {
                    Image("donut")
                    Text("검색 결과가 없어요")
                        .font(.IMHyemin(.body))
                }
                .background(Color.seaSky)
            }
        }
        .safeAreaInset(edge: .top) {
            EmptyView()
                .frame(maxHeight: 125)
        }
        .listStyle(.plain)
        .background(Color.seaSky)
        .scrollContentBackground(.hidden)
        .environment(\.editMode, .constant(isEditMode ? EditMode.active : EditMode.inactive))
        .overlay {
            // MARK: Navigation Bar
            NavigationBar(searchText: $searchText, isEditMode: $isEditMode, isTextFieldActive: $isTextFieldActive, isFocused: _isFocused)
        }
        .onAppear() {
            locationStore.loadLocations()
        }
    }
}


//struct LocationListView_Previews: PreviewProvider {
//
//    static var previews: some View {
//        NavigationView {
//            LocationListView()
//                .preferredColorScheme(.dark)
//        }
//    }
//}
