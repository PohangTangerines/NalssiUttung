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
    
    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { gesture in
                withAnimation(.easeInOut(duration: 0.5)) {
                    print(gesture.translation.height)
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
        VStack(spacing: 0) {
            MainHeader()
            
            if isInitView {
                MainInitView(dailyWeatherData: $dailyWeatherData, canTransition: $canTransition)
                    .transition(.move(edge: .top))
            } else {
                MainScrolledView(weatherBoxData: $weatherBoxData)
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
    
    private struct MainHeader: View {
        let locationText: String = "제주시 애월읍"
        
        var body: some View {
            ZStack {
                HStack {
                    Text("\(locationText)")
                        .font(.pretendardSemibold(.callout))
                    Image(systemName: "location.fill")
                        .font(.system(size: 16, weight: .bold))
                }
                HStack {
                    Spacer()
                    Image(systemName: "plus")
                        .font(.pretendardSemibold(.body))
                }
            }.padding(.top, 7.5).padding(.bottom, 12)
        }
    }
}
