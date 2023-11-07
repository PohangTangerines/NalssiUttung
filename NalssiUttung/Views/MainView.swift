//
//  MainView.swift
//  NalssiUttung
//
//  Created by 이재원 on 2023/10/01.
//

import SwiftUI
import ScrollKit
import WeatherKit

struct MainView: View {
    // MARK: Weather Data 관련
    @ObservedObject var locationManager = LocationManager.shared
    let weatherManager = WeatherService.shared
    
    @State var weatherBoxData: WeatherBoxData?
    @State var dailyWeatherData: DailyWeatherData?
    @State var weeklyWeatherData: WeeklyWeatherData?
    @State var detailedWeatherData: DetailedWeatherData?
    
    // MARK: View 전환 관련
    @State private var dragOffset: CGSize = .zero
    @State private var canTransition = false
    @State private var viewOffsetY: CGFloat = 0
    @State private var isInitView = true

    // MARK: Modal 관련
    @State var modalState: ModalState = .notModalView
    @State var isModalVisible: Bool = false
            
    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { gesture in
                withAnimation(.easeInOut(duration: 0.5)) {
                    if isInitView {
                        if gesture.translation.height < -100 {
                            canTransition = true
                            viewOffsetY = -100
                        } else {
                            canTransition = false
                            viewOffsetY = 0
                        }
                    } else {
                        if gesture.translation.height > 100 {
                            canTransition = true
                            viewOffsetY = 100
                        } else {
                            canTransition = false
                            viewOffsetY = 0
                        }
                    }
                }
            }
            .onEnded { gesture in
                withAnimation {
                    viewOffsetY = 0
                    canTransition = false
                    if isInitView {
                        if gesture.translation.height < -100 {
                            isInitView = false
                        }
                    } else {
                        if gesture.translation.height > 100 {
                            isInitView = true
                        }
                    }
                }
            }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                MainHeader(weatherBoxData: $weatherBoxData, locationText: $locationManager.address, modalState: $modalState, isModalVisible: $isModalVisible)
                    .task {
                        locationManager.getLocationAddress()
                    }

                if isInitView {
                    RealTimeWeatherView(weatherBoxData: $weatherBoxData, dailyWeatherData: $dailyWeatherData, canTransition: $canTransition, isModalVisible: .constant(true))
                        .transition(.move(edge: .top))
                } else {
                    MainScrolledView(weatherBoxData: $weatherBoxData,
                                     weeklyWeatherData: $weeklyWeatherData,
                                     detailedWeatherData: $detailedWeatherData)
                    .transition(.move(edge: .bottom))
                }

            }.padding(.horizontal, 15)
                .gesture(dragGesture)
                .offset(y: viewOffsetY)
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
        
        @ObservedObject var locationStore = LocationStore()

        var body: some View {
            ZStack {
                HStack {
                    if modalState != .notModalView {
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
                        Image(systemName: "추가")
                            .font(.pretendardSemibold(.body))
                            .foregroundColor(.black)
                    }

                }
            }.padding(.top, 7.5).padding(.bottom, 24)
        }
    }
}
