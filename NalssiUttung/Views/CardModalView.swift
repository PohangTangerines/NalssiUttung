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

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                MainHeader(weatherBoxData: $weatherBoxData, locationText: $locationManager.address, modalState: $modalState, isModalVisible: $isModalVisible)
                RealTimeWeatherView(dailyWeatherData: $dailyWeatherData, canTransition: .constant(false), isModalVisible: .constant(false))
                    .transition(.move(edge: .top))
            }.padding(.horizontal, 15)
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

    private struct MainHeader: View {
        @Binding var weatherBoxData: WeatherBoxData?
        @Binding var locationText: String
        @Binding var modalState: ModalState
        @Binding var isModalVisible: Bool

        var body: some View {
            ZStack {
                HStack {
                    if modalState != .notModalView{
                        Button {
                            isModalVisible.toggle()
                        } label: {
                            Image(systemName: "취소")
                                .font(.pretendardSemibold(.body))
                                .foregroundColor(.black)
                        }
                    }
                    Text("\(locationText)")
                        .font(.pretendardSemibold(.callout))
                    Image(systemName: "location.fill")
                        .font(.system(size: 16, weight: .bold))
                }
                HStack {
                    Spacer()
                    switch modalState{
                    case .notModalView:
                        NavigationLink(destination: LocationListView(weatherBoxData: $weatherBoxData, currentLocation: $locationText)) {
                            Image(systemName: "plus")
                                .font(.pretendardSemibold(.body))
                                .foregroundColor(.black)
                        }
                    case .isModalViewAndContainedContent:
                        EmptyView()
                    case .isModalViewAndNotContainedContent:
                        Image(systemName: "추가")
                            .font(.pretendardSemibold(.body))
                            .foregroundColor(.black)
                    }

                }
            }.padding(.top, 7.5).padding(.bottom, 24)
        }
    }
}
