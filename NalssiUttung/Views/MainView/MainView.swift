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
    @ObservedObject var locationStore = LocationStore()
    
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
        // TODO: - Toolbar로 전환 후 변경된 레이아웃 수정 필요
        NavigationView {
            ZStack {
                Color.seaSky
                    .ignoresSafeArea()
                VStack(spacing: 0) {
                    
                    if isInitView {
                        RealTimeWeatherView(weatherBoxData: $weatherBoxData, dailyWeatherData: $dailyWeatherData, canTransition: $canTransition, isModalVisible: .constant(true), isModal: false)
                            .transition(.move(edge: .top))
                    } else {
                        MainScrolledView(weatherBoxData: $weatherBoxData,
                                         weeklyWeatherData: $weeklyWeatherData,
                                         detailedWeatherData: $detailedWeatherData)
                        .transition(.move(edge: .bottom))
                    }
                    
                }
                .padding(.horizontal, 15)
                    .gesture(dragGesture)
                    .offset(y: viewOffsetY)
                    .toolbar(content: toolbarContent)
                    .task {
                        let location = locationManager.currentLocation
                        
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
