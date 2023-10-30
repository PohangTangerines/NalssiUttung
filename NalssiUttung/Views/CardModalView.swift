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
    @Binding var modalState: ModalState
    @Binding var isModalVisible: Bool
    @State var location: String
    @Binding var searchText: String
    
    // MARK: User 위치 정보 저장 관련
    @ObservedObject var locationStore = LocationStore()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                MainHeader(weatherBoxData: $weatherBoxData, location: $location, modalState: $modalState, isModalVisible: $isModalVisible, searchText: $searchText)
                RealTimeWeatherView(dailyWeatherData: $dailyWeatherData, canTransition: .constant(false), isModalVisible: .constant(false))
                    .transition(.move(edge: .top))
            }
            .padding(.horizontal, 15)
            .background(Color.seaSky)
            .task {
                if let location = locationManager.location {
                    if let weather = await weatherManager.getWeather(location: location) {
                        self.weatherBoxData = weatherManager.getWeatherBoxData(location: location, weather: weather)
                        self.dailyWeatherData = weatherManager.getDailyWeatherData(weather: weather)
                        self.weeklyWeatherData = weatherManager.getWeeklyWeatherData(weather: weather)
                        self.detailedWeatherData = weatherManager.getDetailedWeatherData(weather: weather)
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
    @Binding var searchText: String
    
    // MARK: User가 선택한 위치 List 관련 값
    @ObservedObject var locationStore = LocationStore()
    let locations = LocationInfo.Data.map { $0.location }
    
    var body: some View {
        HStack {
            if modalState != .notModalView {
                Button {
                    locationStore.removeLocation()
                    isModalVisible.toggle()
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
                Image(systemName: "location.fill")
                    .font(.system(size: 16, weight: .bold))
            }
            Spacer()
            switch modalState {
            case .notModalView:
                NavigationLink(destination: LocationListView(weatherBoxData: $weatherBoxData, locationStore: locationStore)) {
                    Image(systemName: "plus")
                        .font(.pretendardSemibold(.body))
                        .foregroundColor(.black)
                }
            case .isModalViewAndContainedContent:
                EmptyView()
            case .isModalViewAndNotContainedContent:
                Button {
                    locationStore.addLocation(location)
                    isModalVisible.toggle()
                    searchText = ""
                    print("userDefault: \(locationStore.selectedLocations)")
                } label: {
                    Text("추가")
                        .font(.pretendardSemibold(.body))
                        .foregroundColor(.black)
                }
            }
        }
        .padding(.top, 7.5).padding(.bottom, 24)
    }
}

struct CardModalView_Previews: PreviewProvider {
    static var previews: some View {
        CardModalView(modalState: .constant(.isModalViewAndNotContainedContent), isModalVisible: .constant(true), location: "제주 공항", searchText: .constant(""))
    }
}
