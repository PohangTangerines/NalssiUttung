//
//  MainView.swift
//  NalssiUttung
//
//  Created by 이재원 on 2023/10/01.
//

import SwiftUI
import WeatherKit

struct CardModalView: View {
    // MARK: Weather Data 관련
    @ObservedObject var locationManager = LocationManager.shared
    let weatherManager = WeatherService.shared
    
    @State var weatherBoxData: WeatherBoxData?
    @State var dailyWeatherData: DailyWeatherData?
    @State var weeklyWeatherData: WeeklyWeatherData?
    @State var detailedWeatherData: DetailedWeatherData?
    
    // MARK: Modal 관련
    @State var modalState: ModalState
    @Binding var isModalVisible: Bool
    @State var location: String
    @FocusState var isFocused: Bool
    @Binding var isTextFieldActive: Bool
    @Binding var isEditMode: Bool
    
    // MARK: User 위치 정보 저장 관련
    @Binding var isCurrentLocation: Bool
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                
                MainHeader(weatherBoxData: $weatherBoxData, location: $location, modalState: $modalState, isModalVisible: $isModalVisible, isFocused: _isFocused, isTextFieldActive: $isTextFieldActive, isEditMode: $isEditMode, isCurrentLocation: $isCurrentLocation)
                RealTimeWeatherView(weatherBoxData: $weatherBoxData, dailyWeatherData: $dailyWeatherData, canTransition: .constant(false), isModalVisible: .constant(false))

                    .transition(.move(edge: .top))
            }
            .padding(.horizontal, 15)
            .background(Color.seaSky)
            .task {
                if isCurrentLocation {
                    do {
                        if let location = locationManager.location {
                            if let weather = await weatherManager.getWeather(location: location) {
                                self.weatherBoxData = weatherManager.getWeatherBoxData(location: location, weather: weather)
                                self.dailyWeatherData = weatherManager.getDailyWeatherData(weather: weather)
                            }
                            print("LocationCard success CLlocation")
                            print("현재 온도: \(weatherBoxData?.currentTemperature ?? 00)°C")
                            print("최고 온도: \(weatherBoxData?.highestTemperature ?? 00)°C")
                            print("최저 온도: \(weatherBoxData?.lowestTemperature ?? 00)°C")
                            print("날씨 상태: \(weatherBoxData?.weatherCondition)")
                        }
                    } catch {
                        print("Error LocationCard CLlocation")
                    }
                } else{
                    if let CLlocation = locationManager.findCoordinates(address: location){
                        if let weather = await weatherManager.getWeather(location: CLlocation) {
                            self.weatherBoxData = weatherManager.getWeatherBoxData(location: CLlocation, weather: weather)
                            self.dailyWeatherData = weatherManager.getDailyWeatherData(weather: weather)
                            self.weeklyWeatherData = weatherManager.getWeeklyWeatherData(weather: weather)
                            self.detailedWeatherData = weatherManager.getDetailedWeatherData(weather: weather)
                        }
                    }
                }
            }
        }
    }
}

private struct MainHeader: View {
    @Binding var weatherBoxData: WeatherBoxData?
    @Binding var location: String
    @Binding var modalState: ModalState
    @Binding var isModalVisible: Bool
    @FocusState var isFocused: Bool
    @Binding var isTextFieldActive: Bool
    @Binding var isEditMode: Bool
    @State var storeList: [String]?
    
    // MARK: User가 선택한 위치 List 관련 값
    @ObservedObject var locationStore = LocationStore()
    let locations = LocationInfo.Data.map { $0.location }
    
    @Binding var isCurrentLocation: Bool
    
    var body: some View {
        HStack {
            if modalState != .notModalView {
                Button {
                    isModalVisible = false
                } label: {
                    Text("취소")
                        .font(.pretendardSemibold(.body))
                        .foregroundColor(.black)
                }
            }
            Spacer()
            HStack {
                Text("\(location)")
                    .font(.pretendardSemibold(.callout))
                if isCurrentLocation{
                    Image(systemName: "location.fill")
                        .font(.system(size: 16, weight: .bold))
                }
            }
            Spacer()
            switch modalState {
            case .notModalView:
                NavigationLink(destination: LocationListView(locationStore: locationStore)) {
                    Image(systemName: "plus")
                        .font(.pretendardSemibold(.body))
                        .foregroundColor(.black)
                }
            case .isModalViewAndContainedContent:
                EmptyView()
            case .isModalViewAndNotContainedContent:
                Button {
                    locationStore.saveLocations(come: storeList ?? [])
                    isFocused = false
                    isTextFieldActive = false
                    isEditMode = false
                    isModalVisible = false
                } label: {
                    Text("추가")
                        .font(.pretendardSemibold(.body))
                        .foregroundColor(.black)
                }
                .task {
                    do {
                        var list = try await locationStore.loadLocations()
                        list.append(location)
                        storeList = list
                        print(storeList)
                        print("success storeList in CardModalView")
                    } catch {
                        print("fail storeList in CardModalView")
                    }
                }
            }
        }
        .padding(.top, 30)
        .padding(.bottom, 27)
    }
}
