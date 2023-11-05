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
    
    @ObservedObject var locationStore: LocationStore
    
    // MARK: SearchBar 관련
    @FocusState private var isFocused: Bool
    @State private var searchText = ""
    @State private var isEditMode = false // 삭제 모드 활성화 여부를 추적
    @State var isTextFieldActive = false
    
    // MARK: Modal 관련
    @State private var isModalVisible = false
    @State private var selectedLocationForModal: String?
    
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
                                    print(filteredLocation)
                                    selectedLocationForModal = filteredLocation
                                    isModalVisible.toggle()
                                }
                                .sheet(isPresented: $isModalVisible, content: {
                                    // 새로운 뷰 표시
                                    if let selectedLocationForModal = selectedLocationForModal{
                                        CardModalView(modalState: ModalState.isModalViewAndNotContainedContent, isModalVisible: $isModalVisible, location: selectedLocationForModal, searchText : $searchText)
                                            .onDisappear {
                                                isFocused = false
                                                isTextFieldActive = false
                                            }
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
                                    print(selectedLocation)
                                    selectedLocationForModal = selectedLocation
                                    isModalVisible.toggle()
                                }
                                .sheet(isPresented: $isModalVisible, content: {
                                    // 새로운 뷰 표시
                                    if let selectedLocationForModal = selectedLocationForModal{
                                        CardModalView(modalState: ModalState.isModalViewAndContainedContent, isModalVisible: $isModalVisible, location: selectedLocationForModal, searchText : $searchText)
                                            .onAppear(){
                                                print(selectedLocationForModal)
                                            }
                                    }
                                })
                                .task {
                                    if let weatherData = await weatherManager.getWeatherInfoForAddress(address: selectedLocation) {
                                        self.cardWeatherBoxData = weatherData
                                    } else {
                                        print("날씨 정보를 가져오지 못했습니다.")
                                    }
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
