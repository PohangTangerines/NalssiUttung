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
    let locations = LocationInfo.Data.map { $0.location }
    
    // TODO: 새로운 리스트에 값을 저장하면 보여주도록 하기. 지금은 items에 있는 모든 위치를 다 List로 보여주고 있음.
    @State var locationData: [String] = UserDefaults.standard.stringArray(forKey: "location") ?? []
    @ObservedObject var locationStore: LocationStore
    
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
                    ForEach(filteredLocations, id: \.self) { location in
                        HStack {
                            LocationCard(weatherBoxData: $cardWeatherBoxData, location: location, isCurrentLocation: .constant(false))
                                .frame(maxWidth: .infinity, maxHeight: 140)
                                .listRowSeparator(.hidden)
                                .onTapGesture {
                                    isModalVisible.toggle()
                                    isTextFieldActive.toggle()
                                }
                                .sheet(isPresented: $isModalVisible, content: {
                                    // 새로운 뷰 표시
                                    CardModalView(modalState: $modalState, isModalVisible: $isModalVisible, location: location, searchText : $searchText)
                                        .onDisappear {
                                            isTextFieldActive = false
                                        }
                                })
                                .task {
                                    if let weatherData = await weatherManager.getWeatherInfoForAddress(address: location) {
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
                }
                
                if isTextFieldActive && filteredLocations == [] {
                    VStack {
                        Image("donut")
                            .background(Color.seaSky)
                            .safeAreaInset(edge: .top) {
                                EmptyView()
                                    .frame(maxHeight: 93)
                            }
                        Text("검색 결과가 없어요")
                            .font(.IMHyemin(.body))
                    }
                }

                else {
                    ForEach(locationStore.selectedLocations, id: \.self) { location in
                        HStack {
                            if isEditMode {
                                Image(systemName: "trash.circle.fill")
                                    .foregroundColor(.red)
                                    .onTapGesture {
                                        if let index = locationStore.selectedLocations.firstIndex(of: location) {
                                            locationStore.selectedLocations.remove(at: index)
                                        }
                                    }
                                Spacer()
                            }
                            LocationCard(weatherBoxData: $cardWeatherBoxData, location: location, isCurrentLocation: .constant(false))
                                .frame(maxWidth: .infinity, maxHeight: 140)
                                .listRowSeparator(.hidden)
                                .onTapGesture {
                                    isModalVisible.toggle()
                                    isTextFieldActive.toggle()
                                }
                        }
                        .listRowSeparator(.hidden)
                    }
                    .onMove(perform: locationStore.moveLocation) // 항목 이동 기능
                    .listRowBackground(Color.seaSky)
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
                NavigationBar(searchText: $searchText, isEditMode: $isEditMode, isTextFieldActive: $isTextFieldActive)
            }
            

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
